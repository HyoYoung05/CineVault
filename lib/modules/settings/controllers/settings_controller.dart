import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../app/constants/app_constants.dart';

class SettingsController extends GetxController {
  // Observable variable so the UI updates instantly
  var isBiometricEnabled = false.obs;
  late Box settingsBox;

  @override
  void onInit() {
    super.onInit();
    // Connect to the specific Hive box for settings
    settingsBox = Hive.box(AppConstants.settingsBox);
    
    // Load the saved preference when the controller starts
    isBiometricEnabled.value = settingsBox.get('biometricEnabled', defaultValue: false);
  }

  // Updates both the observable variable and the database
  void toggleBiometric(bool value) {
    isBiometricEnabled.value = value;
    settingsBox.put('biometricEnabled', value);
    
    if (value) {
      Get.snackbar('Vault Secured', 'Biometric lock is now enabled.');
    } else {
      Get.snackbar('Vault Unlocked', 'Biometric lock has been disabled.');
    }
  }
}