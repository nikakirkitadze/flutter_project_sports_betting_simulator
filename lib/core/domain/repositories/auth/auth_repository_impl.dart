import 'package:sports_betting_simulator/core/domain/repositories/auth/auth_repository.dart';
import 'package:sports_betting_simulator/core/models/user_model.dart';
import 'package:sports_betting_simulator/core/services/local_authentication/local_authentication_service.dart';
import 'package:sports_betting_simulator/core/services/login/login_service.dart';
import 'package:sports_betting_simulator/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:sports_betting_simulator/core/utils/constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LoginService _loginService;
  final LocalAuthenticationService _localAuthenticationService;
  final SharedPreferencesService _prefsService;

  AuthRepositoryImpl(
    this._loginService,
    this._localAuthenticationService,
    this._prefsService,
  );

  @override
  Future<User?> login(String username, String password) async {
    final User? user = await _loginService.login(username, password);

    if (user != null) {
      _prefsService.set(AppConstants.usernameKey, username);
      return user;
    } else {
      return null;
    }
  }

  @override
  Future<bool> biometricLogin() async {
    if (!await _localAuthenticationService.canCheckBiometrics()) return false;
    return _localAuthenticationService.authenticate();
  }

  @override
  bool isBiometricEnabled() =>
      _prefsService.get(AppConstants.isBiometricAuthenticationEnabledKey) ??
      false;

  @override
  String storedUsername() {
    return _prefsService.get(AppConstants.usernameKey).toString();
  }
}
