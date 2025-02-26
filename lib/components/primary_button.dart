import 'package:flutter/material.dart';

/// A customizable primary button with animated color transition on press.
///
/// This button changes its background color smoothly when tapped and returns
/// to its original color when released. It supports an onTap callback to
/// handle user interactions.
///
/// Usage:
/// ```dart
/// PrimaryButton(
///   title: "Click Me",
///   onTap: () {
///     print("Button Pressed");
///   },
/// )
/// ```
///
/// Features:
/// - Animated color change when pressed.
/// - Customizable button text.
/// - Rounded corners for a modern look.

class PrimaryButton extends StatefulWidget {
  /// The text displayed on the button.
  final String title;

  /// The callback function triggered when the button is tapped.
  final Function()? onTap;

  const PrimaryButton({super.key, required this.title, required this.onTap});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        height: 48,
        decoration: BoxDecoration(
          color: _isPressed ? Colors.black54 : Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            widget.title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
