import 'package:flutter/material.dart';
import 'package:money_tracker/screens/home_screen.dart';
import 'package:money_tracker/screens/transaction_screen.dart';
import 'package:money_tracker/widgets/navbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  // objek state dashboard
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Variabel untuk menandakan status loading saat logout.
  var isLogoutLoading = false;

  // Variabel untuk menyimpan indeks halaman yang sedang aktif di bottom navigation.
  int currentIndex = 0;

  // List halaman yang akan ditampilkan di dalam PageView.
  var pageViewList = [HomeScreen(), TransactionScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(
          // Mengatur indeks yang dipilih berdasarkan currentIndex
          selectedIndex: currentIndex,
          // Callback saat destinasi dipilih untuk mengubah currentIndex
          onDestinatioSelected: (int value) {
            setState(() {
              currentIndex = value;
            });
          }),
      // Menampilkan halaman yang sesuai dengan currentIndex
      body: pageViewList[currentIndex],
    );
  }
}
