import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_betting_simulator/core/domain/repositories/auth/auth_repository.dart';
import 'package:sports_betting_simulator/features/login/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginStateInitial());

  bool get showBiometricButton => _authRepository.isBiometricEnabled();
  String get storedUsername => _authRepository.storedUsername();

  // Login user with username + password
  Future<void> login(String username, String password) async {
    if (username.isEmpty) {
      emit(LoginStateFailure("Username cannot be empty"));
      return;
    }

    emit(LoginStateLoading());

    try {
      final user = await _authRepository.login(username, password);
      if (user != null) {
        emit(LoginStateSuccess());
      } else {
        emit(LoginStateFailure("Invalid credentials"));
      }
    } catch (e) {
      emit(LoginStateFailure(e.toString()));
    }
  }

  // TODO: differentiate biometric auth and manual auth states
  // now it is emitting LoginStateSuccess
  Future<void> biometricLogin() async {
    emit(LoginStateLoading());
    final success = await _authRepository.biometricLogin();
    success
        ? emit(LoginStateSuccess())
        : emit(LoginStateFailure("Biometric failed"));
  }
}
