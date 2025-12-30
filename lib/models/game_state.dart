// Enum for player symbols
enum Player { x, o }

// Enum for game status
enum GameStatus { playing, xWins, oWins, draw }

// Class to manage the game board state
class XOBoard {
  List<List<Player?>> board;
  Player currentPlayer;
  GameStatus status;
  // Timer properties - each player gets 30 seconds per move
  static const int initialTimePerPlayer = 30;
  int xTimeLeft = initialTimePerPlayer;
  int oTimeLeft = initialTimePerPlayer;
  DateTime? lastMoveTime;
  
  XOBoard()
      : board = List.generate(3, (_) => List.generate(3, (_) => null)),
        currentPlayer = Player.x,
        status = GameStatus.playing,
        lastMoveTime = DateTime.now();

  // Make a move at the specified position
  bool makeMove(int row, int col) {
    // Update time before making the move
    updateTime();
    
    if (board[row][col] != null || status != GameStatus.playing || !hasTimeLeft()) {
      // If no time left, set the status to the winner (opponent wins)
      if (!hasTimeLeft()) {
        status = currentPlayer == Player.x ? GameStatus.oWins : GameStatus.xWins;
      }
      return false;
    }
    
    board[row][col] = currentPlayer;
    _checkGameStatus();
    if (status == GameStatus.playing) {
      _switchPlayer();
    }
    return true;
  }

  // Switch to the other player
  void _switchPlayer() {
    currentPlayer = currentPlayer == Player.x ? Player.o : Player.x;
  }

  // Check if there's a winner or a draw
  void _checkGameStatus() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != null && 
          board[i][0] == board[i][1] && 
          board[i][1] == board[i][2]) {
        status = board[i][0] == Player.x ? GameStatus.xWins : GameStatus.oWins;
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[0][i] != null && 
          board[0][i] == board[1][i] && 
          board[1][i] == board[2][i]) {
        status = board[0][i] == Player.x ? GameStatus.xWins : GameStatus.oWins;
        return;
      }
    }

    // Check diagonals
    if (board[0][0] != null && 
        board[0][0] == board[1][1] && 
        board[1][1] == board[2][2]) {
      status = board[0][0] == Player.x ? GameStatus.xWins : GameStatus.oWins;
      return;
    }
    
    if (board[0][2] != null && 
        board[0][2] == board[1][1] && 
        board[1][1] == board[2][0]) {
      status = board[0][2] == Player.x ? GameStatus.xWins : GameStatus.oWins;
      return;
    }

    // Check for draw
    bool isBoardFull = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == null) {
          isBoardFull = false;
          break;
        }
      }
      if (!isBoardFull) break;
    }
    
    if (isBoardFull) {
      status = GameStatus.draw;
    }
  }
  
  // Public method to check if there's a winner (used by computer player)
  Player? checkWinner() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != null && 
          board[i][0] == board[i][1] && 
          board[i][1] == board[i][2]) {
        return board[i][0];
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[0][i] != null && 
          board[0][i] == board[1][i] && 
          board[1][i] == board[2][i]) {
        return board[0][i];
      }
    }

    // Check diagonals
    if (board[0][0] != null && 
        board[0][0] == board[1][1] && 
        board[1][1] == board[2][2]) {
      return board[0][0];
    }
    
    if (board[0][2] != null && 
        board[0][2] == board[1][1] && 
        board[1][1] == board[2][0]) {
      return board[0][2];
    }
    
    // No winner
    return null;
  }

  // Update time for the current player
  void updateTime() {
    if (lastMoveTime != null) {
      int elapsedSeconds = DateTime.now().difference(lastMoveTime!).inSeconds;
      
      if (currentPlayer == Player.x) {
        xTimeLeft = (xTimeLeft - elapsedSeconds).clamp(0, initialTimePerPlayer);
      } else {
        oTimeLeft = (oTimeLeft - elapsedSeconds).clamp(0, initialTimePerPlayer);
      }
    }
    
    lastMoveTime = DateTime.now();
  }
  
  // Reset the game
  void reset() {
    board = List.generate(3, (_) => List.generate(3, (_) => null));
    currentPlayer = Player.x;
    status = GameStatus.playing;
    xTimeLeft = initialTimePerPlayer;
    oTimeLeft = initialTimePerPlayer;
    lastMoveTime = DateTime.now();
  }
  
  // Check if current player has run out of time
  bool hasTimeLeft() {
    if (currentPlayer == Player.x) {
      return xTimeLeft > 0;
    } else {
      return oTimeLeft > 0;
    }
  }
  
  // Get remaining time for a player
  int getTimeForPlayer(Player player) {
    return player == Player.x ? xTimeLeft : oTimeLeft;
  }
  
  // Format time as MM:SS
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
