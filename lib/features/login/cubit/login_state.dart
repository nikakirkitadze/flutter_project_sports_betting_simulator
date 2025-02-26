abstract class LoginState {}

class LoginStateInitial extends LoginState {}

class LoginStateLoading extends LoginState {}

class LoginStateSuccess extends LoginState {}

class LoginStateFailure extends LoginState {
  final String errorMessage;
  LoginStateFailure(this.errorMessage);
}
