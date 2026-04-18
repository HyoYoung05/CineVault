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
      // Uses Named Routing instead of the deleted screen!
      Get.offAllNamed(Routes.DASHBOARD); 
    } else {
      Get.snackbar('Auth Error', 'Authentication failed or was canceled.');
    }
  }
}