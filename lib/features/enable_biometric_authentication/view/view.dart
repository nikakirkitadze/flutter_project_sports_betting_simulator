import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_betting_simulator/components/primary_button.dart';
import 'package:sports_betting_simulator/components/secondary_button.dart';
import 'package:sports_betting_simulator/core/models/biometric_auth_type.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/cubit/enable_biometric_authentication_cubit.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/cubit/enable_biometric_authentication_state.dart';

class EnableBiometricAuthenticationSheetView extends StatelessWidget {
  const EnableBiometricAuthenticationSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    final biometricAuthCubit =
        context.read<EnableBiometricAuthenticationCubit>();

    return BlocConsumer<
      EnableBiometricAuthenticationCubit,
      EnableBiometricAuthenticationState
    >(
      listener: (context, state) {
        if (state is EnableBiometricAuthenticationStateEnabled) {
          // Close the sheet after 2 seconds
          Future.delayed(
            const Duration(seconds: 2),
            () => Navigator.pop(context),
          );
        }
      },
      builder: (context, state) {
        // Show success UI if enabled
        if (state is EnableBiometricAuthenticationStateEnabled) {
          return _buildSuccessState();
        }

        // Show failure UI
        if (state is EnableBiometricAuthenticationStateFailure) {
          return _buildFailureState(context, state.errorMessage);
        }

        return FutureBuilder<BiometricAuthType?>(
          future: biometricAuthCubit.availableBiometricType(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading biometric type'));
            } else {
              final biometricType = snapshot.data;
              return _buildInitialState(
                context,
                biometricType,
                biometricAuthCubit,
              );
            }
          },
        );
      },
    );
  }

  Widget _buildInitialState(
    BuildContext context,
    BiometricAuthType? biometricType,
    EnableBiometricAuthenticationCubit cubit,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    biometricType == BiometricAuthType.face
                        ? 'assets/icons/face_id.png'
                        : 'assets/icons/touch_id.png',
                    width: 85,
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    biometricType == BiometricAuthType.face
                        ? 'Enable Face ID'
                        : 'Enable Touch ID',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  const Text(
                    'Use your biometrics for quick and secure access to your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            _buildActionButtons(context, cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                  const SizedBox(height: 30.0),
                  const Text(
                    'Biometrics Enabled!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  const Text(
                    'You can now use biometrics to securely access your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailureState(BuildContext context, String message) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 100),
                  const SizedBox(height: 15.0),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 25.0),
                  PrimaryButton(
                    title: 'Close',
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    EnableBiometricAuthenticationCubit cubit,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SecondaryButton(
            title: 'Skip',
            onTap: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: PrimaryButton(
            title: 'Activate',
            onTap: () => _onContinue(context, cubit),
          ),
        ),
      ],
    );
  }

  Future<void> _onContinue(
    BuildContext context,
    EnableBiometricAuthenticationCubit cubit,
  ) async {
    try {
      await cubit.enableBiometricAuthentication();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}
