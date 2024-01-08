import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/utils/appvalidator.dart';
import 'package:money_tracker/widgets/category_dropdown.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  // untuk mengakses dan memanipulasi state form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // Variabel untuk menyimpan jenis transaksi (income/expense), kategori, dan status loading
  var type = 'income';
  var category = 'Others';
  var isLoading = false;
  // untuk validasi input fields
  var appValidator = AppValidator();
  // input fields
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  // objek uuid untuk membuat ID unik
  var uid = Uuid();

  // mengirim submit form ke firestore
  Future<void> _submitForm() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      // Mendapatkan objek user yang sedang login
      final user = FirebaseAuth.instance.currentUser;
      // jam saat ini
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      // mendapatkan nilai dari input amount
      var amount = int.parse(amountEditController.text);
      // tanggal saat ini
      DateTime date = DateTime.now();

      // membuat id unik transaksi
      var id = uid.v4();
      // format bulan & tahun dari tgl saat ini
      String monthyear = DateFormat('MMM y').format(date);
      // mendapat dokumen user dari firebase
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      // mendapat value dari dokumen user
      int remainingAmount = userDoc['remainingAmount'];
      int totalIncome = userDoc['totalIncome'];
      int totalExpense = userDoc['totalExpense'];

      // akumulasi nilai berdasarkan jenis transaksi
      if (type == 'income') {
        remainingAmount += amount;
        totalIncome += amount;
      } else {
        remainingAmount -= amount;
        totalExpense += amount;
      }

      // update nilai dari firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'remainingAmount': remainingAmount,
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'updatedAt': timestamp,
      });
      // data transaksi yg akan ditambahkan ke firestore
      var data = {
        'id': id,
        'title': titleEditController.text,
        'amount': amount,
        'type': type,
        'timestamp': timestamp,
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'remainingAmount': remainingAmount,
        'monthyear': monthyear,
        'category': category,
      };

      // menambahkan data transaksi ke firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(id)
          .set(data);

      // await authService.login(data, context);
      // menutup form setelah selesai menambahkan
      Navigator.pop(context);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextFormField(
              controller: amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            // dropdown utk memilih kategori (iconlist)
            CategoryDropdown(
                cattype: category,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                  }
                }),
            // dropdown utk memilih jenis
            DropdownButtonFormField(
              value: 'income',
              items: [
                DropdownMenuItem(
                  child: Text('Income'),
                  value: 'income',
                ),
                DropdownMenuItem(
                  child: Text('Expense'),
                  value: 'expense',
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    type = value;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  if (isLoading == false) {
                    _submitForm();
                  }
                },
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Text('Add Note Transactions')),
          ],
        ),
      ),
    );
  }
}
