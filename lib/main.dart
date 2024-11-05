import 'package:flutter/material.dart';
import 'package:integrated_odoo/nav_bar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const NavBar(),
        backgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.resolveWith((states) =>
              const Color(0xFFD4F6FF)), 
          dataRowColor:
              MaterialStateProperty.resolveWith((states) => Colors.white),
          columnSpacing: 28,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
