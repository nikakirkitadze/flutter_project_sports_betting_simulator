import 'package:sports_betting_simulator/core/models/biometric_auth_type.dart';

abstract class LocalAuthenticationService {
  Future<bool> canCheckBiometrics();
  Future<List<BiometricAuthType>> getAvailableBiometrics();
  Future<bool> authenticate();
  Future<BiometricAuthType?> getBiometricType();
  Future<bool> isDeviceSupported();
}
