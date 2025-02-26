import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/cubit/enable_biometric_authentication_cubit.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/cubit/enable_biometric_authentication_state.dart';
import 'package:sports_betting_simulator/features/enable_biometric_authentication/view/enable_biometric_authentication.dart';
import 'package:sports_betting_simulator/features/login/view/login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSettingsSectionTitle('Security', context),
              _buildBiometricAuthSetting(context),
              _buildSettingItemListTile(
                context,
                'Password',
                'Update app password',
                Icon(Icons.password, color: Colors.black),
              ),

              _buildSettingsSectionTitle('App Preferences', context),
              _buildSettingItemListTile(
                context,
                'Language',
                'Change the app language.',
                Icon(Icons.language, color: Colors.black),
              ),
              _buildSettingItemListTile(
                context,
                'Appearance',
                'Change app appearance',
                Icon(Icons.dark_mode, color: Colors.black),
              ),

              const SizedBox(height: 30.0),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 20.0,
        bottom: 10.0,
        right: 20.0,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildBiometricAuthSetting(BuildContext context) {
    return Padding(
      // Added padding directly around ListTile for consistent horizontal spacing
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        leading: Icon(Icons.fingerprint, color: Colors.black),
        title: const Text('Biometric Authentication'),
        subtitle: const Text(
          'Enable fingerprint or face recognition for quick login.',
        ),
        trailing: BlocBuilder<
          EnableBiometricAuthenticationCubit,
          EnableBiometricAuthenticationState
        >(
          builder: (context, state) {
            final cubit = context.read<EnableBiometricAuthenticationCubit>();
            return Switch(
              value: cubit.isBiometricEnabled,
              onChanged: (bool newValue) {
                if (newValue) {
                  _showBiometricBottomSheet(context);
                } else {
                  cubit.disableBiometricAuthentication();
                }
              },
            );
          },
        ),
        dense: true,
        contentPadding:
            EdgeInsets.zero, // Remove default ListTile content padding
      ),
    );
  }

  Widget _buildSettingItemListTile(
    BuildContext context,
    String title,
    String subtitle,
    Icon leadingIcon,
  ) {
    return Padding(
      // Added padding directly around ListTile
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        leading: leadingIcon,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Needs to be implemented')));
        },
        dense: true,
        contentPadding:
            EdgeInsets.zero, // Remove default ListTile content padding
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: TextButton.icon(
        onPressed: () {
          _showLogoutConfirmationDialog(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text('Log Out'),
      ),
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [Text('Are you sure you want to logout?')],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            const LoginPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            child,
                  ),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showBiometricBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: EnableBiometricAuthenticationSheet(
              cubit: BlocProvider.of<EnableBiometricAuthenticationCubit>(
                context,
              ),
            ),
          ),
    );
  }
}
