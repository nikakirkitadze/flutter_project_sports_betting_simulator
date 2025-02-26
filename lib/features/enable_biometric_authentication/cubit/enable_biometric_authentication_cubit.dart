import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_betting_simulator/core/models/biometric_auth_type.dart';
import 'package:sports_betting_simulator/core/services/local_authentication/local_authentication_service.dart';
import 'package:sports_betting_simulator/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:sports_betting_simulator/core/utils/constants.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/cubit/enable_biometric_authentication_state.dart';

class EnableBiometricAuthenticationCubit
    extends Cubit<EnableBiometricAuthenticationState> {
  final LocalAuthenticationService _localAuthenticationService;
  final SharedPreferencesService _sharedPreferencesService;

  EnableBiometricAuthenticationCubit(
    this._localAuthenticationService,
    this._sharedPreferencesService,
  ) : super(EnableBiometricAuthenticationStateInitial());

  bool get isBiometricEnabled =>
      _sharedPreferencesService.get(
        AppConstants.isBiometricAuthenticationEnabledKey,
      ) ??
      false;

  Future<BiometricAuthType?> availableBiometricType() async {
    return await _localAuthenticationService.getBiometricType();
  }

  Future<void> enableBiometricAuthentication() async {
    try {
      final authenticated = await _localAuthenticationService.authenticate();
      if (authenticated) {
        // http
        // call backend api to store this information
        // and retrieve token for further / subsequent auth calls

        // mark biometric authentication active
        _sharedPreferencesService.set(
          AppConstants.isBiometricAuthenticationEnabledKey,
          true,
        );

        // based on result of http call with backend for retreiving token
        // return true or false and mark isBiometricAuthenticationEnabled as true
        emit(EnableBiometricAuthenticationStateEnabled());
      } else {
        emit(
          EnableBiometricAuthenticationStateFailure(
            errorMessage: 'Error message',
          ),
        );
      }
    } on PlatformException catch (e) {
      // Catch PlatformException specifically
      _handlePlatformException(e);
    } catch (e) {
      emit(
        EnableBiometricAuthenticationStateFailure(
          errorMessage: 'Authentication failed: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> disableBiometricAuthentication() async {
    _sharedPreferencesService.set(
      AppConstants.isBiometricAuthenticationEnabledKey,
      false,
    );
    emit(EnableBiometricAuthenticationStateDisabled()); // Emit Disabled State
  }

  void _handlePlatformException(PlatformException e) {
    if (e.code == 'LockedOut' || e.code == 'TooManyAttempts') {
      // Check for LockedOut and TooManyAttempts (similar case)
      emit(
        EnableBiometricAuthenticationStateFailure(
          errorMessage:
              'Biometric authentication is locked out due to too many failed attempts. Please try again in 30 seconds or use manual login.',
        ),
      );
    } else if (e.code == 'NotAvailable') {
      emit(
        EnableBiometricAuthenticationStateFailure(
          errorMessage:
              'Biometric authentication is not available on this device.',
        ),
      );
    } else if (e.code == 'OtherOperatingSystem') {
      emit(
        EnableBiometricAuthenticationStateFailure(
          errorMessage:
              'Biometric authentication is not supported on this operating system.',
        ),
      );
    } else if (e.code == 'NoBiometricEnrolled') {
      emit(
        EnableBiometricAuthenticationStateFailure(
          errorMessage:
              'No biometrics have been enrolled on this device. Please enroll biometrics in your device settings.',
        ),
      );
    } else if (e.code == 'AuthFailed') {
      emit(
        EnableBiometricAuthenticationStateFailure(
          errorMessage: 'Biometric authentication failed. Please try again.',
        ),
      );
    } else {
      // For other PlatformExceptions, you can handle them generically or with specific messages as needed.
      emit(
        EnableBiometricAuthenticationStateFailure(
          errorMessage:
              'Biometric authentication error: ${e.message}', // Generic PlatformException message
        ),
      );
    }
  }
}
