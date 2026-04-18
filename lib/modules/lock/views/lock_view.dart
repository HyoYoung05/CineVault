import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lock_controller.dart';

class LockView extends GetView<LockController> {
  const LockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 100, color: Colors.deepPurpleAccent),
            const SizedBox(height: 20),
            const Text(
              'CineVault is Locked',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Obx listens to the isAuthenticating variable in the controller
            Obx(() => ElevatedButton.icon(
              onPressed: controller.isAuthenticating.value ? null : controller.authenticate,
              icon: const Icon(Icons.fingerprint, size: 30),
              label: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  controller.isAuthenticating.value ? 'Scanning...' : 'Unlock Vault', 
                  style: const TextStyle(fontSize: 18)
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
