import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_betting_simulator/components/bordered_text_field.dart';
import 'package:sports_betting_simulator/components/primary_button.dart';
import 'package:sports_betting_simulator/features/login/cubit/login_cubit.dart';
import 'package:sports_betting_simulator/features/login/cubit/login_state.dart';
import 'package:sports_betting_simulator/features/main/main_tab_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginPage> {
  final _usernameTextController = TextEditingController(text: 'testuser');
  final _passwordTextController = TextEditingController(text: 'password123');
  bool _showManualInputFields = false;

  @override
  Widget build(BuildContext context) {
    final showBiometricLoginButton = context.select<LoginCubit, bool>(
      (cubit) => cubit.showBiometricButton,
    );
    final loginCubit = context.read<LoginCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginStateSuccess) {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(builder: (context) => const MainTabPage()),
            );
          }

          if (state is LoginStateFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Quick login layout
              if (showBiometricLoginButton)
                _showManualInputFields
                    ? SizedBox.expand(
                      child: Column(
                        children: [
                          _buildManualLoginLayout(context, loginCubit, state),
                          _buildToggleLoginMethodButton(),
                        ],
                      ),
                    )
                    : _buildQuickLoginLayout(
                      context,
                      loginCubit,
                      showBiometricLoginButton,
                    )
              else
                // Manual login layout
                SizedBox.expand(
                  child: _buildManualLoginLayout(context, loginCubit, state),
                ),

              if (state is LoginStateLoading) _buildLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

  // Manual login layout
  Widget _buildManualLoginLayout(
    BuildContext context,
    LoginCubit loginCubit,
    LoginState state,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildAppTitle(context),
            const SizedBox(height: 60),
            _buildUsernameField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 32),
            _buildLoginButton(context, loginCubit),
          ],
        ),
      ),
    );
  }

  // Quick login layout
  Widget _buildQuickLoginLayout(
    BuildContext context,
    LoginCubit loginCubit,
    bool showBiometricLoginButton,
  ) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 100),
          _buildAppTitle(context),
          Expanded(child: SizedBox.expand()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_showManualInputFields)
                  _buildQuickLoginButton(context, loginCubit)
                else
                  _buildManualLoginFields(context, loginCubit),
                const SizedBox(height: 16),
                _buildToggleLoginMethodButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Loading spinner overlay
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: .5),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }

  Widget _buildAppTitle(BuildContext context) {
    return Center(
      child: Text(
        "Sports Betting",
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return BorderedTextField(
      controller: _usernameTextController,
      hintText: "Username",
      keyboardType: TextInputType.emailAddress,
      autoFocus: !_showManualInputFields,
    );
  }

  Widget _buildPasswordField() {
    return BorderedTextField(
      controller: _passwordTextController,
      hintText: "Password",
      isObscureText: true,
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginCubit loginCubit) {
    return PrimaryButton(
      title: "Login",
      onTap: () => _performLogin(context, loginCubit),
    );
  }

  Widget _buildQuickLoginButton(BuildContext context, LoginCubit loginCubit) {
    return GestureDetector(
      onTap: () => loginCubit.biometricLogin(),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loginCubit.storedUsername,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "example@domain.com",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.fingerprint,
              size: 36,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualLoginFields(BuildContext context, LoginCubit loginCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildUsernameField(),
        const SizedBox(height: 16),
        _buildPasswordField(),
        const SizedBox(height: 32),
        _buildLoginButton(context, loginCubit),
      ],
    );
  }

  // Switch between quick login / manual login
  Widget _buildToggleLoginMethodButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _showManualInputFields = !_showManualInputFields;
        });
      },
      child: Text(
        _showManualInputFields ? "Use quick login" : "Use another account",
      ),
    );
  }

  void _performLogin(BuildContext context, LoginCubit loginCubit) {
    loginCubit.login(
      _usernameTextController.text,
      _passwordTextController.text,
    );
  }
}
