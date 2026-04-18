import '../providers/biometric_provider.dart';

class AuthService {
  final BiometricProvider _biometricProvider = BiometricProvider();

  // The service uses the provider to return a simple true/false to the controllers
  Future<bool> unlockVault() async {
    return await _biometricProvider.authenticate();
  }
}