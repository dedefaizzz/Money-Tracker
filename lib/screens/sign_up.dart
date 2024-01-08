import 'package:flutter/material.dart';
import 'package:money_tracker/services/auth_services.dart';
import 'package:money_tracker/styles/styles.dart';
import 'package:money_tracker/utils/appvalidator.dart';
import 'package:money_tracker/screens/login.dart';

// ignore: must_be_immutable
class SignUpView extends StatefulWidget {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // TextEditingController untuk masing-masing input field
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  // utk akses dan manipulasi form state (validasi & submission)
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // Objek AuthService untuk mengelola proses otentikasi
  var authService = AuthService();
  var isLoading = false;

  // Method untuk mengirimkan data pendaftaran ke AuthService
  Future<void> _submitForm() async {
    // Validasi form sebelum mengirim data
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      // Membuat objek data dengan informasi yang diambil dari input fields yg ada di firebase
      var data = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'phone': _phoneController.text,
        'remainingAmount': 0,
        'totalIncome': 0,
        'totalExpense': 0,
      };

      // memanggil createUser utk membuat akun baru
      await authService.createUser(data, context);

      setState(() {
        isLoading = false;
      });

      // ScaffoldMessenger.of(_formkey.currentContext!).showSnackBar(
      //   const SnackBar(content: Text('Form Submitted Successfully')),
      // );
    }
  }

  // validasi input fields
  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          // bagian dari row dapat mengambil sisa ruang yang tersedia.
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      const SizedBox(
                        width: 250,
                        child: Text(
                          'Create New Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        controller: _usernameController,
                        style: labelStyle,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration:
                            _buildInputDecoration('Username', Icons.people),
                        validator: appValidator.validateUsername,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: labelStyle,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _buildInputDecoration('Email', Icons.email),
                        validator: appValidator.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: labelStyle,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration:
                            _buildInputDecoration('Phone Number', Icons.phone),
                        validator: appValidator.validatePhoneNumber,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        style: labelStyle,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration:
                            _buildInputDecoration('Password', Icons.lock),
                        obscureText: true,
                        validator: appValidator.validatePassword,
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            isLoading ? print('Loading') : _submitForm();
                          },
                          child: isLoading
                              ? Center(child: CircularProgressIndicator())
                              : const Text(
                                  'Create',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color:
                                          Color.fromARGB(255, 251, 250, 250)),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginView()),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.green, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // method utk style
  InputDecoration _buildInputDecoration(String label, IconData prefixIcon) =>
      InputDecoration(
        fillColor: fillColor,
        filled: true,
        labelStyle: labelStyle,
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(prefixIcon, color: prefixIconColor),
      );
}
