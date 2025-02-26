import 'package:flutter/material.dart';

class ClubLogo extends StatelessWidget {
  final String logoPath;
  final bool? hasStroke;
  final double width;
  final double height;

  const ClubLogo({
    super.key,
    required this.logoPath,
    this.hasStroke,
    this.width = 36.0,
    this.height = 36.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      foregroundDecoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            hasStroke == true
                ? Border.all(color: Color(0xFF2B2B3D), width: 2.0)
                : null,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF222232),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Image.asset(
          logoPath,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.sports_soccer,
              color: Colors.white54,
              size: 16,
            );
          },
        ),
      ),
    );
  }
}
