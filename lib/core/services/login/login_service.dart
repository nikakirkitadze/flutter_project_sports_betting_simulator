import 'package:sports_betting_simulator/core/models/user_model.dart';

abstract class LoginService {
  Future<User?> login(String username, String password);
  Future<bool> continueBiometricLogin(String token);
}
