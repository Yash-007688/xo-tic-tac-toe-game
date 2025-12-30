import 'package:flutter/material.dart';
import 'xo_button.dart';
import '../models/game_state.dart';

class GameBoard extends StatelessWidget {
  final XOBoard game;
  final Function(int, int) onSquarePressed;
  final double buttonSize;

  const GameBoard({
    super.key,
    required this.game,
    required this.onSquarePressed,
    this.buttonSize = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF4E342E) // Darker brown for dark theme
            : const Color(0xFF8B4513), // SaddleBrown for light theme
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.black).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        // Adding a wooden grain effect with gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [
                  const Color(0xFF6D4C41), // Darker brown for dark theme
                  const Color(0xFF4E342E), // Even darker brown
                  const Color(0xFF6D4C41), // Darker brown for dark theme
                ]
              : [
                  const Color(0xFFA0522D), // Sienna for light theme
                  const Color(0xFF8B4513), // SaddleBrown
                  const Color(0xFFA0522D), // Sienna for light theme
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
        // Adding border to enhance wooden look
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF3E2723) // Darker border for dark theme
              : const Color(0xFF654321), // Darker brown border for light theme
          width: 3,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              XOButton(
                player: game.board[0][0],
                onPressed: () => onSquarePressed(0, 0),
                size: buttonSize,
              ),
              const SizedBox(width: 10),
              XOButton(
                player: game.board[0][1],
                onPressed: () => onSquarePressed(0, 1),
                size: buttonSize,
              ),
              const SizedBox(width: 10),
              XOButton(
                player: game.board[0][2],
                onPressed: () => onSquarePressed(0, 2),
                size: buttonSize,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Second row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              XOButton(
                player: game.board[1][0],
                onPressed: () => onSquarePressed(1, 0),
                size: buttonSize,
              ),
              const SizedBox(width: 10),
              XOButton(
                player: game.board[1][1],
                onPressed: () => onSquarePressed(1, 1),
                size: buttonSize,
              ),
              const SizedBox(width: 10),
              XOButton(
                player: game.board[1][2],
                onPressed: () => onSquarePressed(1, 2),
                size: buttonSize,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Third row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              XOButton(
                player: game.board[2][0],
                onPressed: () => onSquarePressed(2, 0),
                size: buttonSize,
              ),
              const SizedBox(width: 10),
              XOButton(
                player: game.board[2][1],
                onPressed: () => onSquarePressed(2, 1),
                size: buttonSize,
              ),
              const SizedBox(width: 10),
              XOButton(
                player: game.board[2][2],
                onPressed: () => onSquarePressed(2, 2),
                size: buttonSize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
