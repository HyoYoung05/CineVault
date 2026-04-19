import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/app_snackbar.dart';

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

      if (destination is Map) {
        final route = destination['route'];
        final arguments = destination['arguments'];

        if (route is String && route.isNotEmpty) {
          Get.offNamed(route, arguments: arguments);
        } else {
          Get.offAllNamed(Routes.DASHBOARD);
        }
      } else if (destination is String && destination.isNotEmpty) {
        Get.offNamed(destination);
      } else {
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } else {
      AppSnackbar.show(
        'Auth Error',
        'Authentication failed or was canceled.',
        isError: true,
      );
    }
  }
}
