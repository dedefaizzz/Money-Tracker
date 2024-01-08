import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/widgets/category_list.dart';
import 'package:money_tracker/widgets/tab_bar_view.dart';
import 'package:money_tracker/widgets/time_line_month.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  // Variabel untuk menyimpan kategori transaksi yang sedang dipilih
  var category = 'All';
  // Variabel untuk menyimpan bulan dan tahun yang sedang ditampilkan
  var monthYear = '';

  // inisialisasi variabel saat pertama kali widget dibuat
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      // mengambil bulan & tahun saat ini dgn dateformat
      monthYear = DateFormat('MMM y').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expansive'),
      ),
      // widget menampilkan time line bulan
      body: Column(
        children: [
          TimeLineMonth(
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  monthYear = value;
                });
              }
            },
          ),
          // Widget CategoryList untuk menampilkan daftar kategori transaksi
          CategoryList(
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  category = value;
                });
              }
            },
          ),
          // filter utk history transaksi
          TypeTabBar(category: category, monthYear: monthYear),
        ],
      ),
    );
  }
}
