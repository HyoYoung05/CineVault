import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // Show splash for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    final settingsBox = Hive.box(AppConstants.settingsBox);
    final startupScreen = settingsBox.get(
      AppConstants.defaultStartupScreenKey,
      defaultValue: 'home',
    ) as String;

    if (startupScreen == 'vault') {
      Get.offNamed(Routes.WATCHLIST, arguments: {'mode': 'vault'});
    } else {
      Get.offNamed(Routes.DASHBOARD);
    }
  }
}
