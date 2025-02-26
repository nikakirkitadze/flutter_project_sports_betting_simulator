import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:sports_betting_simulator/core/models/biometric_auth_type.dart';
import 'package:sports_betting_simulator/core/services/local_authentication/local_authentication_service.dart';

class DefaultLocalAuthenticationService implements LocalAuthenticationService {
  final LocalAuthentication _localAuth;
  final bool _isAndroid;

  DefaultLocalAuthenticationService({
    LocalAuthentication? localAuth,
    bool? isAndroid,
  }) : _localAuth = localAuth ?? LocalAuthentication(),
       _isAndroid =
           isAndroid ?? (defaultTargetPlatform == TargetPlatform.android);

  @override
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BiometricAuthType>> getAvailableBiometrics() async {
    try {
      final biometrics = await _localAuth.getAvailableBiometrics();
      return biometrics.map(_convertBiometricType).toList();
    } catch (e) {
      return [];
    }
  }

  BiometricAuthType _convertBiometricType(BiometricType type) {
    if (_isAndroid) {
      // Android-specific handling
      switch (type) {
        case BiometricType.strong:
        case BiometricType.weak:
          return BiometricAuthType.fingerprint;
        default:
          return BiometricAuthType.none;
      }
    }
    // iOS handling
    return type == BiometricType.face
        ? BiometricAuthType.face
        : BiometricAuthType.fingerprint;
  }

  @override
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your account',
        authMessages: [
          AndroidAuthMessages(
            signInTitle: 'Authentication Required',
            biometricHint: '',
            cancelButton: 'Cancel',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true, // Important for Android background transitions
        ),
      );
    } on PlatformException catch (_) {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<BiometricAuthType> getBiometricType() async {
    try {
      final available = await getAvailableBiometrics();
      if (available.contains(BiometricAuthType.face)) {
        return BiometricAuthType.face;
      }

      if (available.contains(BiometricAuthType.fingerprint)) {
        return BiometricAuthType.fingerprint;
      }
      return BiometricAuthType.none;
    } catch (e) {
      return BiometricAuthType.none;
    }
  }

  @override
  Future<bool> isDeviceSupported() async {
    if (_isAndroid) {
      return await _localAuth.isDeviceSupported();
    }
    return await canCheckBiometrics();
  }
}
