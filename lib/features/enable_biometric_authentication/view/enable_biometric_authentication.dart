import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/cubit/enable_biometric_authentication_cubit.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/view/view.dart';

class EnableBiometricAuthenticationSheet extends StatelessWidget {
  final EnableBiometricAuthenticationCubit cubit;

  const EnableBiometricAuthenticationSheet({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // Use BlocProvider.value to provide the Cubit
      value: cubit, // Provide the 'cubit' parameter here
      child:
          const EnableBiometricAuthenticationSheetView(), // Now View can access the Cubit
    );
  }
}
