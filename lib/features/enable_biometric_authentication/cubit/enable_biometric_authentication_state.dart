abstract class EnableBiometricAuthenticationState {}

class EnableBiometricAuthenticationStateInitial
    extends EnableBiometricAuthenticationState {}

class EnableBiometricAuthenticationStateLoading
    extends EnableBiometricAuthenticationState {}

class EnableBiometricAuthenticationStateSuccess
    extends EnableBiometricAuthenticationState {}

class EnableBiometricAuthenticationStateEnabled
    extends EnableBiometricAuthenticationState {}

class EnableBiometricAuthenticationStateFailure
    extends EnableBiometricAuthenticationState {
  final String errorMessage;
  EnableBiometricAuthenticationStateFailure({required this.errorMessage});
}

class EnableBiometricAuthenticationStateDisabled
    extends EnableBiometricAuthenticationState {}
