// Computer player with adjustable difficulty
import 'dart:math';
import 'game_state.dart';

enum DifficultyLevel { easy, medium, tough }

class XOComputerPlayer {
  static DifficultyLevel currentDifficulty = DifficultyLevel.medium;
  
  final XOBoard game;
  final Random _random = Random();

  XOComputerPlayer(this.game);

  List<int> makeMove() {
    switch (currentDifficulty) {
      case DifficultyLevel.easy:
        return _makeEasyMove();
      case DifficultyLevel.medium:
        return _makeMediumMove();
      case DifficultyLevel.tough:
        return _makeToughMove();
    }
  }

  // Easy: Mostly random moves with occasional smart moves
  List<int> _makeEasyMove() {
    // 20% chance of making a smart move, 80% random
    if (_random.nextDouble() < 0.2) {
      return _makeSmartMove();
    } else {
      return _makeRandomMove();
    }
  }

  // Medium: Mix of smart and random moves
  List<int> _makeMediumMove() {
    // 50% chance of making a smart move, 50% random
    if (_random.nextDouble() < 0.5) {
      return _makeSmartMove();
    } else {
      return _makeRandomMove();
    }
  }

  // Tough: Mostly smart moves with occasional random moves
  List<int> _makeToughMove() {
    // 90% chance of making a smart move, 10% random
    if (_random.nextDouble() < 0.9) {
      return _makeSmartMove();
    } else {
      return _makeRandomMove();
    }
  }

  // Makes the best possible move using minimax algorithm
  List<int> _makeSmartMove() {
    // First, try to win
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (game.board[i][j] == null) {
          game.board[i][j] = Player.o;
          Player? winner = game.checkWinner();
          game.board[i][j] = null; // Reset test
          if (winner == Player.o) {
            return [i, j];
          }
        }
      }
    }

    // Then, block opponent from winning
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (game.board[i][j] == null) {
          game.board[i][j] = Player.x;
          Player? winner = game.checkWinner();
          game.board[i][j] = null; // Reset test
          if (winner == Player.x) {
            return [i, j];
          }
        }
      }
    }

    // Try to take center if available
    if (game.board[1][1] == null) {
      return [1, 1];
    }

    // Try to take corners
    List<List<int>> corners = [[0, 0], [0, 2], [2, 0], [2, 2]];
    List<List<int>> availableCorners = [];
    for (var corner in corners) {
      if (game.board[corner[0]][corner[1]] == null) {
        availableCorners.add(corner);
      }
    }
    if (availableCorners.isNotEmpty) {
      return availableCorners[_random.nextInt(availableCorners.length)];
    }

    // Otherwise make a random move
    return _makeRandomMove();
  }

  // Makes a completely random move
  List<int> _makeRandomMove() {
    List<List<int>> availableMoves = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (game.board[i][j] == null) {
          availableMoves.add([i, j]);
        }
      }
    }

    if (availableMoves.isNotEmpty) {
      return availableMoves[_random.nextInt(availableMoves.length)];
    }

    // This shouldn't happen if game is still playable
    return [0, 0];
  }
}
