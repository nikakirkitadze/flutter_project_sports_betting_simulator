import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sports_betting_simulator/core/models/user_model.dart';
import 'package:sports_betting_simulator/features/login/cubit/login_cubit.dart';
import 'package:sports_betting_simulator/features/login/cubit/login_state.dart';

import '../../../mocks/repositories/mock_auth_repository.dart';

void main() {
  late LoginCubit loginCubit;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginCubit = LoginCubit(mockAuthRepository);
  });

  group('LoginCubit', () {
    test('initial state is LoginStateInitial', () {
      expect(loginCubit.state, isA<LoginStateInitial>());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [Loading, Success] when login succeeds',
      build: () {
        when(() => mockAuthRepository.login(any(), any())).thenAnswer(
          (_) async => User(username: 'username'),
        ); // Replace with your User object
        return loginCubit;
      },
      act: (cubit) => cubit.login('testuser', 'password123'),
      expect: () => [isA<LoginStateLoading>(), isA<LoginStateSuccess>()],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [Loading, Failure] when login fails',
      build: () {
        when(
          () => mockAuthRepository.login(any(), any()),
        ).thenThrow(Exception('Invalid credentials'));
        return loginCubit;
      },
      act: (cubit) => cubit.login('wrong', 'wrong'),
      expect: () => [isA<LoginStateLoading>(), isA<LoginStateFailure>()],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [Loading, Failure] when username is empty',
      build: () => loginCubit,
      act: (cubit) => cubit.login('', 'password'),
      expect:
          () => [
            predicate<LoginStateFailure>(
              (state) =>
                  state.errorMessage.contains('Username cannot be empty'),
            ),
          ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [Loading, Success] when biometric login succeeds',
      build: () {
        when(
          () => mockAuthRepository.biometricLogin(),
        ).thenAnswer((_) async => true);
        return loginCubit;
      },
      act: (cubit) => cubit.biometricLogin(),
      expect: () => [isA<LoginStateLoading>(), isA<LoginStateSuccess>()],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [Loading, Failure] when biometric login fails',
      build: () {
        when(
          () => mockAuthRepository.biometricLogin(),
        ).thenAnswer((_) async => false);
        return loginCubit;
      },
      act: (cubit) => cubit.biometricLogin(),
      expect: () => [isA<LoginStateLoading>(), isA<LoginStateFailure>()],
    );

    test('showBiometricButton returns correct value', () {
      when(() => mockAuthRepository.isBiometricEnabled()).thenReturn(true);
      expect(loginCubit.showBiometricButton, true);

      when(() => mockAuthRepository.isBiometricEnabled()).thenReturn(false);
      expect(loginCubit.showBiometricButton, false);
    });
  });
}
