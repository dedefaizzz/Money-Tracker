import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/utils/icons_list.dart';

// menampilkan recent transaksi
// ignore: must_be_immutable
class TransactionCard extends StatelessWidget {
  TransactionCard({
    super.key,
    required this.data,
  });

  final dynamic data; // menyimpan info transaksi
  var appIcons =
      AppIcons(); // instance dari class iconList yg menyediakan icon category

  @override
  Widget build(BuildContext context) {
    // convert timestamp ke object datetime
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);

    // format tgl
    String formatedDate = DateFormat('d MMM hh:mma').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        // UI recent transaction
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 10),
                  color: Colors.grey.withOpacity(0.09),
                  blurRadius: 10.0,
                  spreadRadius: 4.0),
            ]),
        child: ListTile(
          // Menetapkan jarak vertikal minimum dan padding konten
          minVerticalPadding: 10,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          // Bagian kiri dari ListTile, berisi ikon dan kategori transaksi
          leading: Container(
            width: 70,
            height: 100,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: data['type'] == 'income'
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(
                        0.2), // warna border sesuai jenis transaksi
              ),
              child: Center(
                child: FaIcon(
                  // Mengambil ikon kategori transaksi
                  appIcons.getExpenseCategoryIcons('${data['category']}'),
                  // Menetapkan warna ikon sesuai jenis transaksi
                  color: data['type'] == 'income' ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
          // Bagian tengah dari ListTile, berisi judul dan jumlah transaksi
          title: Row(
            children: [
              Expanded(child: Text('${data['title']}')),
              Text(
                '${data['type'] == 'income' ? '+' : '-'}Rp ${data['amount']}',
                style: TextStyle(
                  color: data['type'] == 'income' ? Colors.green : Colors.red,
                ),
              )
            ],
          ),
          // Bagian bawah dari ListTile, berisi informasi saldo dan tanggal transaksi
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Balance',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Spacer(),
                  // Menampilkan saldo terkini dengan format mata uang
                  Text('Rp ${data['remainingAmount']}',
                      style: TextStyle(color: Colors.grey, fontSize: 12))
                ],
              ),
              Text(
                // Menampilkan tanggal transaksi yang sudah diformat
                formatedDate,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
