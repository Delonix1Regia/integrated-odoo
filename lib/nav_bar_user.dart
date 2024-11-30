import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:integrated_odoo/view/admin/fakultas_view.dart';
import 'package:integrated_odoo/view/admin/mhs_view.dart';
import 'package:integrated_odoo/view/admin/prodi_view.dart';
import 'package:integrated_odoo/view/user/fakultas_view_user.dart';
import 'package:integrated_odoo/view/user/mhs_view_user.dart';
import 'package:integrated_odoo/view/user/prodi_view_user.dart';
import 'login_screen.dart'; // Pastikan untuk mengimpor login_screen.dart

class NavBarUser extends StatefulWidget {
  const NavBarUser({super.key});

  @override
  State<NavBarUser> createState() => _NavBarState();
}

class _NavBarState extends State<NavBarUser> {
  List<Widget> pages = [
    FakultasViewUser(),
    ProdiViewUser(),
    MhsViewUser(),
  ];
  int pageCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('User Dashboard'),
      // ),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.book),
          Icon(Icons.school),
          Icon(Icons.person),
          Icon(Icons.logout), // Tambahkan tombol logout
        ],
        onTap: (value) {
          if (value == 3) {
            // Saat logout, arahkan kembali ke halaman login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          } else {
            setState(() {
              pageCount = value;
            });
          }
        },
        color: Colors.transparent,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.transparent,
        height: 60.0,
      ),
      body: pages[pageCount],
    );
  }
}
