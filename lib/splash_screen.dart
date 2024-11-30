import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false, // Menghapus semua route sebelumnya
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Image.asset('assets/images/icon.png'),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar posisi di tengah
              children: [
                Image.asset(
                  'assets/images/student.gif',
                  width: 350, // Ukuran gambar
                  height: 350,
                ),
                const SizedBox(height: 20), // Jarak antara gambar dan teks
                const Text(
                  'TRACER ALUMNI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
