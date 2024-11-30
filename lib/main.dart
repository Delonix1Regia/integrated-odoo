import 'package:flutter/material.dart';
import 'package:integrated_odoo/login_screen.dart';
import 'splash_screen.dart'; // Import file SplashScreen

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(), // SplashScreen ditampilkan pertama
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.resolveWith(
              (states) => const Color(0xFFD4F6FF)),
          dataRowColor:
              MaterialStateProperty.resolveWith((states) => Colors.white),
          columnSpacing: 28,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
