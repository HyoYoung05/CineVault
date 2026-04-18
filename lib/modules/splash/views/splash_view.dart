import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // We initialize the controller here to trigger the timer
    Get.put(SplashController());

    return const Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_filter, size: 100, color: Colors.deepPurpleAccent),
            SizedBox(height: 20),
            Text(
              'CINEVAULT',
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold, 
                letterSpacing: 4
              ),
            ),
          ],
        ),
      ),
    );
  }
}