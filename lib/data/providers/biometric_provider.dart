import 'package:local_auth/local_auth.dart';

class BiometricProvider {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final bool canAuthenticate = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      if (!canAuthenticate) return false;

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access CineVault',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
