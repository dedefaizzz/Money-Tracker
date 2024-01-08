import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/screens/dashboard.dart';
import 'package:money_tracker/services/db.dart';

class AuthService {
  var db = Db();
  // Metode createUser untuk membuat akun baru berdasarkan data yang diberikan
  createUser(data, context) async {
    try {
      // Membuat user baru menggunakan email dan password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );

      // menambah data user ke database
      await db.addUser(data, context);
      // navigasi ke dashboard setelah berhasil dibuat
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (e) {
      // error jika salah saat membuat akun
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sign up failed'),
              content: Text(e.toString()),
            );
          });
    }
  }

  // method login
  login(data, context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Login error'),
              content: Text(e.toString()),
            );
          });
    }
  }
}
