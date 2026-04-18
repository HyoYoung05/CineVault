import 'package:get/get.dart';
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
    Get.offNamed(Routes.DASHBOARD);
  }
}
