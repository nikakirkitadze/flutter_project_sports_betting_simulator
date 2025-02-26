import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_betting_simulator/core/domain/repositories/auth/auth_repository.dart';
import 'package:sports_betting_simulator/core/domain/repositories/auth/auth_repository_impl.dart';
import 'package:sports_betting_simulator/core/domain/repositories/games/games_repository.dart';
import 'package:sports_betting_simulator/core/domain/repositories/games/games_repository_impl.dart';
import 'package:sports_betting_simulator/core/services/games/games_service.dart';
import 'package:sports_betting_simulator/core/services/games/local_games_service.dart';
import 'package:sports_betting_simulator/core/services/local_authentication/default_local_authentication_service.dart';
import 'package:sports_betting_simulator/core/services/local_authentication/local_authentication_service.dart';
import 'package:sports_betting_simulator/core/services/login/default_login_service.dart';
import 'package:sports_betting_simulator/core/services/login/login_service.dart';
import 'package:sports_betting_simulator/core/services/shared_preferences/default_shared_preferences_service.dart';
import 'package:sports_betting_simulator/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:sports_betting_simulator/core/themes/light_mode.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/cubit/enable_biometric_authentication_cubit.dart';
import 'package:sports_betting_simulator/features/login/cubit/login_cubit.dart';
import 'package:sports_betting_simulator/features/login/view/login_page.dart';

class SportsApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const SportsApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Add all required service providers
        // SharedPreferencesService provider
        RepositoryProvider<SharedPreferencesService>(
          create:
              (_) => DefaultSharedPreferencesService(
                preferences: sharedPreferences,
              ),
        ),
        // LocalAuthenticationService provider
        RepositoryProvider<LocalAuthenticationService>(
          create:
              (_) => DefaultLocalAuthenticationService(
                isAndroid: Platform.isAndroid,
              ),
        ),
        // LoginService provider
        RepositoryProvider<LoginService>(
          create: (context) {
            final localAuth = context.read<LocalAuthenticationService>();
            return DefaultLoginService(localAuthenticationService: localAuth);
          },
        ),
        // AuthRepository provider
        RepositoryProvider<AuthRepository>(
          create:
              (context) => AuthRepositoryImpl(
                context.read<LoginService>(),
                context.read<LocalAuthenticationService>(),
                context.read<SharedPreferencesService>(),
              ),
        ),
        RepositoryProvider<GamesService>(create: (_) => LocalGamesService()),
        RepositoryProvider<GamesRepository>(
          create:
              (context) => GamesRepositoryImpl(context.read<GamesService>()),
        ),
        BlocProvider(
          create:
              (context) => EnableBiometricAuthenticationCubit(
                context.read<LocalAuthenticationService>(),
                context.read<SharedPreferencesService>(),
              ),
        ),
      ],
      child: BlocProvider(
        create: (context) => LoginCubit(context.read<AuthRepository>()),
        child: MaterialApp(
          title: 'Sports Betting Simulator',
          theme: lightMode,
          home: LoginPage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
