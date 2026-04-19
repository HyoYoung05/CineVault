import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void show(
    String title,
    String message, {
    bool isError = false,
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      borderRadius: 16,
      duration: const Duration(seconds: 2),
      backgroundColor: isError ? const Color(0xFF7A1F1F) : const Color(0xFF1E1E1E),
      colorText: const Color(0xFFFFFFFF),
    );
  }
}
