import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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

  Widget buildTextField(TextEditingController controller,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  void registerUser() async {
    _showLoadingDialog();
    var url = 'https://iamthetoolsmanagement.000webhostapp.com/register.php';
    var response = await http.post(
      Uri.parse(url),
      body: {
        'email': emailController.text,
        'username': usernameController.text,
        'password': passwordController.text,
        'isAdmin': "0",
      },
    );

    _hideLoadingDialog();

    var responseData = json.decode(response.body);
    if (responseData['status'] == 'success') {
      _showSuccessDialog();
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Data berhasil disimpan.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          buildTextField(emailController),
          const SizedBox(height: 16),
          buildInputSection(Icons.person, 'Username:'),
          const SizedBox(height: 8),
          buildTextField(usernameController),
          const SizedBox(height: 16),
          buildInputSection(Icons.lock, 'Password:'),
          const SizedBox(height: 8),
          buildTextField(passwordController, obscureText: true),
          const SizedBox(height: 16),
          buildInputSection(Icons.lock, 'Confirm Password:'),
          const SizedBox(height: 8),
          buildTextField(confirmPasswordController, obscureText: true),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text == confirmPasswordController.text) {
                registerUser();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Password dan konfirmasi password tidak cocok')),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.app_registration),
                SizedBox(width: 8),
                Text('Daftar'),
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
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'Sudah Punya Akun? Login disini',
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
