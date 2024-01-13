import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/widgets/transaction_card.dart';

// menampilkan daftar transaksi pada antarmuka pengguna
class TransactionList extends StatelessWidget {
  TransactionList(
      {super.key,
      required this.category,
      required this.type,
      required this.monthYear});

  // Mengambil ID pengguna yang sedang masuk
  final userId = FirebaseAuth.instance.currentUser!.uid;
  // Variabel untuk menyimpan kategori, jenis, dan bulan dan tahun transaksi
  final String category;
  final String type;
  final String monthYear;

  @override
  Widget build(BuildContext context) {
    // Membuat query untuk mendapatkan data transaksi dari Firestore
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .where('monthyear', isEqualTo: monthYear)
        .where('type', isEqualTo: type);

    // Jika kategori bukan 'All' (semua transaksi), maka kategori transaksi tertentu saja
    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    // menangani status async dan mendapatkan data dari Firebase Firestore
    return FutureBuilder<QuerySnapshot>(
      future: query.limit(150).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong'); // menampilkan error
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading"); // menampilkan jika data sdg dimuat
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text(
                  'No Transactions found')); // menampilkan jika tidak ada data
        }

        // Jika data transaksi tersedia, membuat ListView untuk menampilkan daftar transaksi
        var data = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var cardData = data[index];
            // menggunakan TransactionCard utk merender setiap kartu
            return TransactionCard(
              data: cardData,
            );
          },
        );
      },
    );
  }
}
