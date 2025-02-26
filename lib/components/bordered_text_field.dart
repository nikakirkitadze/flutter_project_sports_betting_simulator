import 'package:flutter/material.dart';

/// A reusable text field with a bordered outline.
///
/// This widget provides a customizable text input field with an optional
/// password mode, hint text, and keyboard type.
///
/// Usage:
/// ```dart
/// BorderedTextField(
///   controller: myController,
///   hintText: "Enter your email",
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
///
/// Features:
/// - Customizable hint text.
/// - Optional password input mode (`isObscureText`).
/// - Supports different keyboard types.
/// - Styled with a border for better visibility.

class BorderedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? isObscureText;
  final TextInputType? keyboardType;
  final bool? autoFocus;

  const BorderedTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscureText,
    this.keyboardType,
    this.autoFocus,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscureText ?? false,
      keyboardType: keyboardType,
      autofocus: autoFocus ?? false,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: Colors.grey[200],
        hintText: hintText,
        filled: true,
      ),
    );
  }
}
