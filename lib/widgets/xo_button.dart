import 'package:flutter/material.dart';
import '../models/game_state.dart';

class XOButton extends StatelessWidget {
  final Player? player;
  final VoidCallback onPressed;
  final double size;

  const XOButton({
    super.key,
    required this.player,
    required this.onPressed,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    String text = '';
    Color color = Colors.transparent;

    if (player == Player.x) {
      text = 'X';
      color = Theme.of(context).brightness == Brightness.dark
          ? Colors.red.shade400 // Lighter red for dark theme
          : Colors.red.shade700; // Darker red for light theme
    } else if (player == Player.o) {
      text = 'O';
      color = Theme.of(context).brightness == Brightness.dark
          ? Colors.blue.shade400 // Lighter blue for dark theme
          : Colors.blue.shade700; // Darker blue for light theme
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF5D4037) // Darker brown for dark theme
            : const Color(0xFFF5DEB3), // Wheat color for light theme
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.black).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF3E2723) // Darker brown border for dark theme
              : const Color(0xFF8B4513), // SaddleBrown border for light theme
          width: 2,
        ),
        // Adding subtle gradient for 3D wooden effect
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [
                  const Color(0xFF6D4C41), // Darker brown for dark theme
                  const Color(0xFF5D4037), // Dark brown
                  const Color(0xFF4E342E), // Even darker brown
                ]
              : [
                  const Color(0xFFFFF8DC), // Cornsilk for light theme
                  const Color(0xFFF5DEB3), // Wheat
                  const Color(0xFFEEDFCC), // Lighter wheat
                ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: size * 0.5,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
