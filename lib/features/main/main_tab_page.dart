import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_betting_simulator/core/domain/repositories/games/games_repository.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_bloc.dart';
import 'package:sports_betting_simulator/features/betting/bloc/betting_event.dart';
import 'package:sports_betting_simulator/features/betting/view/betting_page.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/cubit/enable_biometric_authentication_cubit.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/view/enable_biometric_authentication.dart';
import 'package:sports_betting_simulator/features/settings/settings_page.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  Timer? _timer;
  // current tab index
  int _currentIndex = 0;
  late BettingBloc _bettingBloc;

  // all pages
  final List<Widget> _pages = const [
    BettingPage(), // Index 0: BettingPage
    SettingsPage(), // Index 1: SettingsPage
  ];

  @override
  void initState() {
    super.initState();
    _bettingBloc = BettingBloc(context.read<GamesRepository>())
      ..add(LoadGames()); // Create BettingBloc once
    _startBiometricPromptTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bettingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bettingBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Sports Betting')),
        body: _pages[_currentIndex], // Display the page based on current index
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Betting'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  void _startBiometricPromptTimer() {
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        final biometricCubit =
            context.read<EnableBiometricAuthenticationCubit>();
        // if biometric auth is not enabled show bottom sheet
        if (!biometricCubit.isBiometricEnabled) {
          _showBiometricBottomSheet();
        }
      }
    });
  }

  void _showBiometricBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: BlocProvider.value(
              value: context.read<EnableBiometricAuthenticationCubit>(),
              child: EnableBiometricAuthenticationSheet(
                cubit: context.read<EnableBiometricAuthenticationCubit>(),
              ),
            ),
          ),
    );
  }
}
