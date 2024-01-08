import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/screens/login.dart';
import 'package:money_tracker/widgets/add_transaction_form.dart';
import 'package:money_tracker/widgets/hero_card.dart';
import 'package:money_tracker/widgets/transactions_cards.dart';

// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
class HomeScreen extends StatefulWidget {
  //constructor
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variabel untuk menandakan status loading saat logout
  var isLogoutLoading = false;

  // method utk logout
  logOut() async {
    setState(() {
      isLogoutLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginView()),
    );

    setState(() {
      isLogoutLoading = false;
    });
  }

  // Mendapatkan user ID dari pengguna yang saat ini login
  final userId = FirebaseAuth.instance.currentUser!.uid;

  // layout berupa alert dialog
  _dialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: AddTransactionForm(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: (() {
          _dialogBuilder(context);
        }),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Hello, Dede',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // tombol logout
          IconButton(
              onPressed: () {
                logOut();
              },
              // indikator loading jika sedang logout
              icon: isLogoutLoading
                  ? Center(child: CircularProgressIndicator())
                  : Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroCard(userId: userId),
            TransactionsCard(),
          ],
        ),
      ),
    );
  }
}
