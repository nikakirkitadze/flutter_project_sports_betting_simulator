import 'package:sports_betting_simulator/core/models/user_model.dart';

abstract class AuthRepository {
  Future<User?> login(String username, String password);
  Future<bool> biometricLogin();
  bool isBiometricEnabled();
  String storedUsername();
}
