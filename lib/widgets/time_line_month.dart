import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// menampilkan list bulan pada history transaksi
class TimeLineMonth extends StatefulWidget {
  // constructor TimeLineMonth dengan parameter onChanged yang merupakan fungsi yang akan dipanggil ketika bulan berubah
  const TimeLineMonth({super.key, required this.onChanged});
  final ValueChanged<String?> onChanged;

  @override
  State<TimeLineMonth> createState() => _TimeLineMonthState();
}

class _TimeLineMonthState extends State<TimeLineMonth> {
  String currentMonth = ''; // menyimpan bulan saat ini yg dipilih
  List<String> months = []; // menyimpan daftar bulan yg akan ditampilkan
  final scrollController = ScrollController(); // mengontrol behavior scrolling

  @override
  void initState() {
    super.initState();

    // dapat tgl & waktu saat ini
    DateTime now = DateTime.now();

    // list bulan dgn 12 bulan terhitung bulan saat ke 1 tahun sebelumnya
    for (var i = -12; i <= 0; i++) {
      months.add(
          DateFormat('MMM y').format(DateTime(now.year, now.month + i, 1)));
    }

    // setting currentMonth dgn bulan saat ini
    currentMonth = DateFormat('MMM y').format(now);

    // Menggunakan Future.delayed untuk menunggu beberapa detik sebelum menjalankan scrollToSelectedMonth
    Future.delayed(
      Duration(seconds: 1),
      () {
        scrollToSelectedMonth();
      },
    );
  }

  // untuk menggulir ke bulan yang dipilih
  scrollToSelectedMonth() {
    final selectedMonthIndex = months.indexOf(currentMonth);
    if (selectedMonthIndex != -1) {
      final scrollOffset = (selectedMonthIndex * 100.0) - 170;
      // animasi scroll
      scrollController.animateTo(scrollOffset,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
          controller: scrollController,
          itemCount: months.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // update currentmonth dan manggil fungsi onchaged
                setState(() {
                  currentMonth = months[index];
                  widget.onChanged(months[index]);
                });
                // Menggulir ke bulan yang dipilih setelah mengubah currentMonth
                scrollToSelectedMonth();
              },
              child: Container(
                width: 100,
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: currentMonth == months[index]
                        ? Colors.deepPurple
                        : Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  months[index],
                  style: TextStyle(
                      color: currentMonth == months[index]
                          ? Colors.white
                          : Colors.purple),
                )),
              ),
            );
          }),
    );
  }
}
