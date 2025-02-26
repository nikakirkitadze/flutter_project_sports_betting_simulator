import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sports_betting_simulator/core/models/biometric_auth_type.dart';
import 'package:sports_betting_simulator/core/utils/constants.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/cubit/enable_biometric_authentication_cubit.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/cubit/enable_biometric_authentication_state.dart';

import '../../../mocks/services/mock_local_authentication_service.dart';
import '../../../mocks/services/mock_shared_preferences_service.dart';

void main() {
  late EnableBiometricAuthenticationCubit cubit;
  late MockLocalAuthenticationService mockLocalAuthService;
  late MockSharedPreferencesService mockSharedPrefsService;

  setUp(() {
    mockLocalAuthService = MockLocalAuthenticationService();
    mockSharedPrefsService = MockSharedPreferencesService();
    cubit = EnableBiometricAuthenticationCubit(
      mockLocalAuthService,
      mockSharedPrefsService,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('EnableBiometricAuthenticationCubit', () {
    test('initial state is EnableBiometricAuthenticationStateInitial', () {
      expect(cubit.state, isA<EnableBiometricAuthenticationStateInitial>());
    });

    blocTest<
      EnableBiometricAuthenticationCubit,
      EnableBiometricAuthenticationState
    >(
      'emits [EnableBiometricAuthenticationStateEnabled] when authentication succeeds',
      build: () {
        when(
          () => mockLocalAuthService.authenticate(),
        ).thenAnswer((_) async => true);
        when(
          () => mockSharedPrefsService.set(
            AppConstants.isBiometricAuthenticationEnabledKey,
            true,
          ),
        ).thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.enableBiometricAuthentication(),
      expect: () => [isA<EnableBiometricAuthenticationStateEnabled>()],
      verify: (_) {
        verify(() => mockLocalAuthService.authenticate()).called(1);
        verify(
          () => mockSharedPrefsService.set(
            AppConstants.isBiometricAuthenticationEnabledKey,
            true,
          ),
        ).called(1);
      },
    );

    blocTest<
      EnableBiometricAuthenticationCubit,
      EnableBiometricAuthenticationState
    >(
      'emits [EnableBiometricAuthenticationStateFailure] when authentication fails',
      build: () {
        when(
          () => mockLocalAuthService.authenticate(),
        ).thenAnswer((_) async => false);
        return cubit;
      },
      act: (cubit) => cubit.enableBiometricAuthentication(),
      expect: () => [isA<EnableBiometricAuthenticationStateFailure>()],
      verify: (_) {
        verify(() => mockLocalAuthService.authenticate()).called(1);
        verifyNever(
          () => mockSharedPrefsService.set(
            AppConstants.isBiometricAuthenticationEnabledKey,
            any(),
          ),
        );
      },
    );

    blocTest<
      EnableBiometricAuthenticationCubit,
      EnableBiometricAuthenticationState
    >(
      'emits [EnableBiometricAuthenticationStateFailure] when authentication throws an exception',
      build: () {
        when(
          () => mockLocalAuthService.authenticate(),
        ).thenThrow(Exception('Authentication failed'));
        return cubit;
      },
      act: (cubit) => cubit.enableBiometricAuthentication(),
      expect: () => [isA<EnableBiometricAuthenticationStateFailure>()],
      verify: (_) {
        verify(() => mockLocalAuthService.authenticate()).called(1);
        verifyNever(
          () => mockSharedPrefsService.set(
            AppConstants.isBiometricAuthenticationEnabledKey,
            any(),
          ),
        );
      },
    );

    test('isBiometricEnabled returns correct value from SharedPreferences', () {
      when(
        () => mockSharedPrefsService.get(
          AppConstants.isBiometricAuthenticationEnabledKey,
        ),
      ).thenReturn(true);
      expect(cubit.isBiometricEnabled, true);

      when(
        () => mockSharedPrefsService.get(
          AppConstants.isBiometricAuthenticationEnabledKey,
        ),
      ).thenReturn(false);
      expect(cubit.isBiometricEnabled, false);
    });

    test('availableBiometricType returns correct type', () async {
      when(
        () => mockLocalAuthService.getBiometricType(),
      ).thenAnswer((_) async => BiometricAuthType.face);
      expect(await cubit.availableBiometricType(), BiometricAuthType.face);

      when(
        () => mockLocalAuthService.getBiometricType(),
      ).thenAnswer((_) async => BiometricAuthType.fingerprint);
      expect(
        await cubit.availableBiometricType(),
        BiometricAuthType.fingerprint,
      );
    });
  });
}
