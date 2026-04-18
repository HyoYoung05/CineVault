import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Obx(() => SwitchListTile(
              title: const Text('Enable Biometric Lock'),
              subtitle: const Text('Require fingerprint or face ID to access your private Watchlist.'),
              value: controller.isBiometricEnabled.value,
              onChanged: controller.toggleBiometric,
              secondary: Icon(
                Icons.fingerprint, 
                color: controller.isBiometricEnabled.value ? Colors.deepPurpleAccent : Colors.grey,
              ),
              activeThumbColor: Colors.deepPurpleAccent,
            )),
          ),
        ],
      ),
    );
  }
}