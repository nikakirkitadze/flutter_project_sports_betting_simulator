import 'dart:async';

import 'package:sports_betting_simulator/core/models/user_model.dart';
import 'package:sports_betting_simulator/core/services/local_authentication/local_authentication_service.dart';
import 'package:sports_betting_simulator/core/services/login/login_service.dart';

class DefaultLoginService extends LoginService {
  final LocalAuthenticationService localAuthenticationService;

  DefaultLoginService({required this.localAuthenticationService});

  @override
  Future<User?> login(String username, String password) async {
    // Dummy credentials check
    if (username == 'testuser' && password == 'password123') {
      return Future.delayed(
        const Duration(seconds: 3),
        () => User(username: username),
      );
    }
    return null;
  }

  @override
  Future<bool> continueBiometricLogin(String token) async {
    try {
      bool canCheckBiometrics =
          await localAuthenticationService.canCheckBiometrics();
      if (!canCheckBiometrics) return false;
      return await localAuthenticationService.authenticate();
    } catch (e) {
      return false;
    }
  }
}
