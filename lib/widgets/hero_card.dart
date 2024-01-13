import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class herocard untuk menampilkan informasi saldo pengguna
class HeroCard extends StatelessWidget {
  // parameter key dan userId
  HeroCard({
    super.key,
    required this.userId,
  });
  final String userId; // menyimpan id pengguna

  @override
  Widget build(BuildContext context) {
    // stream yg melakukan perubahan dokumen di firestore
    final Stream<DocumentSnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();

    // build UI berdasarkan snapshot dari stream
    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong'); // jika terjadi kesalahan
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text(
              'Document does not exist'); // jika tidak ada dokumen
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading"); // stream menunggu data
        }
        // mendapatkan data dari snapshot
        var data = snapshot.data!.data() as Map<String, dynamic>;

        // widget cards dgn data yg disimpan
        return Cards(
          data: data,
        );
      },
    );
  }
}

// menampilkan saldo & statistik pengguna
class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.data,
  });
  final Map data; // menyimpan data pengguna

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // bagian saldo pengguna
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rp ${data['remainingAmount']}',
                  style: TextStyle(
                      fontSize: 38,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // UI pemasukan & pengeluaran
          Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                // bagian pemasukan & pengeluaran
                child: Row(
                  children: [
                    CardOne(
                      color: Colors.green,
                      heading: 'Income',
                      amount: '${data['totalIncome']}',
                    ),
                    SizedBox(width: 10),
                    CardOne(
                      color: Colors.red,
                      heading: 'Expense',
                      amount: '${data['totalExpense']}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// menampilkan pendapatan / pengeluaran
class CardOne extends StatelessWidget {
  const CardOne({
    super.key,
    required this.color,
    required this.heading,
    required this.amount,
  });

  final Color color; // menyimpan background
  final String heading; // menyimpan judul kartu (income / expense)
  final String amount; // menyimpan jml income / expense

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            // bagian field kiri (judul dan jumlah)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: TextStyle(color: color, fontSize: 15),
                  ),
                  Text(
                    'Rp ${amount}',
                    style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Spacer(),
            // field kanan icon income / expense
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                heading == 'Income' ? Icons.arrow_upward : Icons.arrow_downward,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
