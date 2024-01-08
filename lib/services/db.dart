import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// utk interaksi dgn firestore
class Db {
  // objek users yg merepresentasikan collection users
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(data, context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Menambahkan data pengguna ke Firestore menggunakan user ID sebagai dokumen
    await users
        .doc(userId)
        .set(data)
        .then((value) => print("User Added"))
        .catchError((error) {
      // Menampilkan dialog alert jika terjadi error saat menambahkan data pengguna
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Login error'),
              content: Text(error.toString()),
            );
          });
    });
  }
}
