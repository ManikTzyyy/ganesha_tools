// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert';
import 'package:my_first_flutter/Pages/registerPage.dart';
import 'package:my_first_flutter/Pages/user/homePageUser.dart';
import 'package:my_first_flutter/Pages/admin/homePageAdmin.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  Widget buildInputSection(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget buildTextField({bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword && !_passwordVisible,
      controller: isPassword ? passwordController : emailController,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void loginUser() async {
    _showLoadingDialog();
    var url = 'https://iamthetoolsmanagement.000webhostapp.com/login.php';
    var response = await http.post(
      Uri.parse(url),
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );
    _hideLoadingDialog();
    var responseData = json.decode(response.body);
    if (responseData['status'] == 'success') {
      String role = responseData['role']; // Assuming your API returns 'role'
      dynamic idUser =
          responseData['idUser']; // Use dynamic type to handle potential null

      if (idUser != null) {
        // Navigate based on role
        if (role == 'user') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(
                  idUser: idUser.toString()), // Convert idUser to String
            ),
          );
        } else if (role == 'admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => homePageAdmin(
                  idUser: idUser.toString()), // Convert idUser to String
            ),
          );
        } else {
          _showErrorDialog('Invalid role received');
        }
      } else {
        _showErrorDialog('idUser is null or invalid');
      }
    } else {
      _showErrorDialog(responseData['message']);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 50,
            ),
          ),
        );
      },
    );
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoadingDialog() {
    if (_isLoading) {
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(height: 20),
          buildInputSection(Icons.email, 'Email:'),
          const SizedBox(height: 8),
          buildTextField(),
          const SizedBox(height: 16),
          buildInputSection(Icons.lock, 'Kata Sandi:'),
          const SizedBox(height: 8),
          buildTextField(isPassword: true),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              loginUser();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.login),
                SizedBox(width: 8),
                Text('Masuk'),
              ],
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black, // Warna teks tombol
              padding: EdgeInsets.symmetric(
                  horizontal: 25.0, vertical: 15.0), // Ukuran padding tombol
              textStyle: TextStyle(
                fontSize: 16.0, // Ukuran teks tombol
                fontWeight: FontWeight.bold, // Berat teks tombol
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8.0), // Bentuk border tombol
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => RegisterScreen()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person_add, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'Belum punya akun? Daftar disini',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
