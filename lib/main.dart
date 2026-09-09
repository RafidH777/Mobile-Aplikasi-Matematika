import 'package:flutter/material.dart';

import 'screen/login.dart';
import 'screen/home.dart';
import 'screen/kelompok.dart';
import 'screen/kalkulator.dart';
import 'screen/ganjilgenap.dart';
import 'screen/deret.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Pemrograman Dart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/kelompok': (context) => const KelompokScreen(),
        '/kalkulator': (context) => const KalkulatorScreen(),
        '/ganjil-genap': (context) => const GanjilGenapScreen(),
        '/deret': (context) => const DeretScreen(),
      },
    );
  }
}