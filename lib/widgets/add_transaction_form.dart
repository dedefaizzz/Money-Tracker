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
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var type = 'income';
  var category = 'Others';
  var isLoading = false;
  var appValidator = AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = Uuid();

  Future<void> _submitForm() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      var amount = int.parse(amountEditController.text);
      DateTime date = DateTime.now();

      var id = uid.v4();
      String monthyear = DateFormat('MMM y').format(date);
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      int remainingAmount = userDoc['remainingAmount'];
      int totalIncome = userDoc['totalIncome'];
      int totalExpense = userDoc['totalExpense'];

      if (type == 'income') {
        remainingAmount += amount;
        totalIncome += amount;
      } else {
        remainingAmount -= amount;
        totalExpense += amount;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'remainingAmount': remainingAmount,
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'updatedAt': timestamp,
      });
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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(id)
          .set(data);

      // await authService.login(data, context);
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
            CategoryDropdown(
                cattype: category,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                  }
                }),
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
