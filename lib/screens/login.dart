import 'package:flutter/material.dart';
import 'package:money_tracker/services/auth_services.dart';
import 'package:money_tracker/styles/styles.dart';
import 'package:money_tracker/utils/appvalidator.dart';
import 'package:money_tracker/screens/sign_up.dart';

// ignore: must_be_immutable
class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // utk akses dan manipulasi form state (validasi & submission)
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var authService = AuthService();
  var isLoading = false;

  Future<void> _submitForm() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var data = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      await authService.login(data, context);

      setState(() {
        isLoading = false;
      });
    }
  }

  // utk akses dan manipulasi form state (validasi & submission)
  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              const SizedBox(
                width: 250,
                child: Text(
                  'Login Account',
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: labelStyle,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _buildInputDecoration('Email', Icons.email),
                validator: appValidator.validateEmail,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                style: labelStyle,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _buildInputDecoration('Password', Icons.lock),
                obscureText: true,
                validator: appValidator.validatePassword,
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    isLoading ? print('Loading') : _submitForm();
                  },
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 251, 250, 250)),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpView()),
                  );
                },
                child: const Text(
                  'Create New Account',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
