import 'package:flutter/material.dart';
import 'package:money_tracker/utils/icons_list.dart';

// digunakan utk menampilkan dropdown menu kategori transaksi
// ignore: must_be_immutable
class CategoryDropdown extends StatelessWidget {
  CategoryDropdown({super.key, this.cattype, required this.onChanged});
  // var utk menyimpan tipe kategori
  final String? cattype;
  // callback onChanged dipanggil ketika nilai dropdown berubah
  final ValueChanged<String?> onChanged;
  // utk mengakses database icon
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: cattype,
        isExpanded: true,
        hint: Text('Select Category'),
        items: appIcons.homeExpensesCategories
            .map((e) => DropdownMenuItem<String>(
                value: e['name'],
                // Setiap item dropdown berisi ikon dan nama kategori
                child: Row(
                  children: [
                    Icon(
                      e['icon'],
                      color: Colors.black45,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      e['name'],
                      style: TextStyle(color: Colors.black45),
                    ),
                  ],
                )))
            .toList(),
        // onChanged digunakan ketika nilai dropdown berubah
        onChanged: onChanged);
  }
}
