import 'package:local_auth/local_auth.dart';

class BiometricProvider {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      if (!canAuthenticateWithBiometrics) return false;

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access CineVault',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
    } catch (e) {
      return false;
    }
  }
}