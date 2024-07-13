import 'package:flutter/material.dart';
import 'Pages/loginPage.dart';
import 'Pages/registerPage.dart';
import 'Pages/splashscreen.dart';

import 'Pages/admin/homePageAdmin.dart';
import 'Pages/admin/elecAdmin.dart';
import 'Pages/admin/nonelecAdmin.dart';
import 'Pages/admin/detailAdmin.dart';
import 'Pages/admin/formAdmin.dart';



import 'Pages/user/electroList.dart';
import 'Pages/user/homePageUser.dart';
import 'Pages/user/notElectroList.dart';
import 'Pages/user/formPinjaman.dart';

import 'Pages/detailListPage.dart';


// ignore: unused_import



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GANESHA TOOLS',
      home: SplashScreen(),
      routes: {
        
        '/splashScreen': (context) => SplashScreen(),
        // '/profilePage': (context) => ProfileScreen(),
        

        // global pageS
        '/loginPage': (context) => LoginScreen(),
        '/registerPage': (context) => RegisterScreen(),
        '/detailPage': (context) => ItemDetail(item: {}, idUser: '',),


        // userPage
        '/homePageUser': (context) => HomePage(idUser: '',),
        '/electroList': (context) => electroList(idUser: '',),
        '/notElectroList': (context) => notElectroList(idUser: '',),
        '/formPinjaman': (context) => formPinjaman(idUser: '', idAlat: '',),
        

        // adminPage
        '/homePageAdmin': (context) => homePageAdmin(idUser: '',),
        '/elecAdmin': (context) => elecAdmin(idUser: '',),
        '/nonelecAdmin': (context) => nonelecAdmin(idUser: '',),
        '/detailAdmin': (context) => itemdetailAdmin(idUser: '', item: {},),
        '/formAdmin': (context) => formEdit(idUser: '', idAlat: '',),
      },
    );
  }
}
