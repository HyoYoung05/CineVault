import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../app/routes/app_routes.dart';

class LockController extends GetxController {
  var isAuthenticating = false.obs;
  final AuthService _authService = AuthService();

  Future<void> authenticate() async {
    isAuthenticating.value = true;
    
    // Calls the service layer we created earlier
    bool authenticated = await _authService.unlockVault();
    
    isAuthenticating.value = false;

    if (authenticated) {
      final destination = Get.arguments;

      if (destination is String && destination.isNotEmpty) {
        Get.offNamed(destination);
      } else {
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } else {
      Get.snackbar('Auth Error', 'Authentication failed or was canceled.');
    }
  }
}
