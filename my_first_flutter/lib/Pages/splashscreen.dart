import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_first_flutter/Pages/loginPage.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}