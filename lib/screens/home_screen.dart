import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/computer_player.dart';
import '../widgets/game_board.dart';
import '../providers/theme_provider.dart';
import '../providers/instructor_provider.dart';
import '../widgets/chat_widget.dart';
import 'dart:async';

enum GameMode { playerVsPlayer, playerVsComputer }

class GameScreen extends StatefulWidget {
  final String? gameMode;

  const GameScreen({super.key, this.gameMode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final XOBoard _game = XOBoard();
  XOComputerPlayer? _computerPlayer;
  late GameMode _gameMode = GameMode.playerVsPlayer;
  bool _isGameActive = true;
  Player _humanPlayer = Player.x; // Human is always X in computer mode
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Set game mode based on passed argument
    if (widget.gameMode == 'player_vs_computer') {
      _gameMode = GameMode.playerVsComputer;
    } else {
      _gameMode = GameMode.playerVsPlayer;
    }
    _computerPlayer = XOComputerPlayer(_game);

    // Start the timer to update every second
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isGameActive && _game.status == GameStatus.playing) {
        setState(() {
          _game.updateTime();

          // Check if current player has run out of time
          if (!_game.hasTimeLeft()) {
            _isGameActive = false;
            _game.status = _game.currentPlayer == Player.x ? GameStatus.oWins : GameStatus.xWins;
            
            // Notify instructor of game event
            if (_gameMode == GameMode.playerVsComputer) {
              final instructorProvider = Provider.of<InstructorProvider>(context, listen: false);
              instructorProvider.onGameEvent(_game.status, _game.currentPlayer);
            }
          }
        });
      }
    });
  }

  void _makeMove(int row, int col) {
    if (_isGameActive && _game.makeMove(row, col)) {
      setState(() {
        _isGameActive = _game.status == GameStatus.playing;

        // If playing against computer and game is still active,
        // and it's computer's turn, make computer move
        if (_gameMode == GameMode.playerVsComputer &&
            _isGameActive &&
            _game.currentPlayer != _humanPlayer) {
          _makeComputerMove();
        }
      });
      
      // Notify instructor of game event if game status changed
      if (_gameMode == GameMode.playerVsComputer) {
        final instructorProvider = Provider.of<InstructorProvider>(context, listen: false);
        instructorProvider.onGameEvent(_game.status, _game.currentPlayer);
      }
    }
  }

  void _makeComputerMove() {
    if (_gameMode == GameMode.playerVsComputer &&
        _isGameActive &&
        _game.currentPlayer != _humanPlayer) {

      // Small delay to make it look like computer is thinking
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_isGameActive && _game.status == GameStatus.playing) {
          List<int> computerMove = _computerPlayer!.makeMove();
          int row = computerMove[0];
          int col = computerMove[1];
          if (_game.makeMove(row, col)) {
            setState(() {
              _isGameActive = _game.status == GameStatus.playing;
            });
            
            // Notify instructor of game event if game status changed
            if (_gameMode == GameMode.playerVsComputer) {
              final instructorProvider = Provider.of<InstructorProvider>(context, listen: false);
              instructorProvider.onGameEvent(_game.status, _game.currentPlayer);
            }
          }
        }
      });
    }
  }

  void _resetGame() {
    setState(() {
      _game.reset();
      _isGameActive = true;
      _computerPlayer = XOComputerPlayer(_game);
    });
  }

  void _setGameMode(GameMode mode) {
    setState(() {
      _gameMode = mode;
      _resetGame();
    });
  }

  String _getGameStatusText() {
    if (_gameMode == GameMode.playerVsComputer &&
        _game.currentPlayer == _humanPlayer &&
        _isGameActive) {
      return 'Your Turn (X)';
    } else if (_gameMode == GameMode.playerVsComputer &&
               _game.currentPlayer != _humanPlayer &&
               _isGameActive) {
      return 'Computer Thinking... (O)';
    }

    switch (_game.status) {
      case GameStatus.xWins:
        if (_gameMode == GameMode.playerVsComputer && _humanPlayer == Player.x) {
          return 'You Win!';
        } else if (_gameMode == GameMode.playerVsComputer && _humanPlayer != Player.x) {
          return 'Computer Wins!';
        } else {
          return 'Player X Wins!';
        }
      case GameStatus.oWins:
        if (_gameMode == GameMode.playerVsComputer && _humanPlayer == Player.o) {
          return 'You Win!';
        } else if (_gameMode == GameMode.playerVsComputer && _humanPlayer != Player.o) {
          return 'Computer Wins!';
        } else {
          return 'Player O Wins!';
        }
      case GameStatus.draw:
        return 'It''s a Draw!';
      default:
        return 'Player ''s Turn';
    }
  }

  Color _getStatusTextColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      switch (_game.status) {
        case GameStatus.xWins:
          if (_gameMode == GameMode.playerVsComputer && _humanPlayer == Player.x) {
            return Colors.green.shade400;
          } else {
            return Colors.red.shade400;
          }
        case GameStatus.oWins:
          if (_gameMode == GameMode.playerVsComputer && _humanPlayer == Player.o) {
            return Colors.green.shade400;
          } else {
            return Colors.blue.shade400;
          }
        case GameStatus.draw:
          return Colors.orange.shade400;
        default:
          return Colors.white70;
      }
    } else {
      switch (_game.status) {
        case GameStatus.xWins:
          if (_gameMode == GameMode.playerVsComputer && _humanPlayer == Player.x) {
            return Colors.green.shade700;
          } else {
            return Colors.red.shade700;
          }
        case GameStatus.oWins:
          if (_gameMode == GameMode.playerVsComputer && _humanPlayer == Player.o) {
            return Colors.green.shade700;
          } else {
            return Colors.blue.shade700;
          }
        case GameStatus.draw:
          return Colors.orange.shade700;
        default:
          return Colors.black87;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XO Tic Tac Toe'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF3E2723) // Dark brown for dark theme
            : Colors.brown.shade600, // Light brown for light theme
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkTheme
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            tooltip: 'Home',
          ),
          if (_gameMode == GameMode.playerVsComputer) // Only show instructor icon in computer mode
            IconButton(
              icon: const Icon(Icons.school),
              onPressed: () {
                Navigator.pushNamed(context, '/instructor_selection');
              },
              tooltip: 'Instructors',
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    Colors.grey.shade800,
                    Colors.grey.shade900,
                  ]
                : [
                    Colors.brown.shade100,
                    Colors.brown.shade50,
                  ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Timer display
              Container(
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF4E342E) // Darker brown for dark theme
                      : const Color(0xFFF5DEB3), // Wheat color to match wooden theme
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.black).withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF5D4037) // Darker brown border
                        : const Color(0xFF8B4513), // SaddleBrown border
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // X Player Timer
                    Column(
                      children: [
                        Text(
                          'X',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.red.shade400
                                : Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _game.formatTime(_game.getTimeForPlayer(Player.x)),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.amber.shade200
                                : Colors.brown.shade800,
                          ),
                        ),
                        if (_game.currentPlayer == Player.x && _isGameActive)
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.red.shade900
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.red.shade700
                                    : Colors.red.shade300,
                              ),
                            ),
                            child: Text(
                              'Your Turn',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.red.shade200
                                    : Colors.red.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    // VS Text
                    Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.amber.shade200
                            : Colors.brown.shade800,
                      ),
                    ),
                    // O Player Timer
                    Column(
                      children: [
                        Text(
                          'O',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.blue.shade400
                                : Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _game.formatTime(_game.getTimeForPlayer(Player.o)),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.amber.shade200
                                : Colors.brown.shade800,
                          ),
                        ),
                        if (_game.currentPlayer == Player.o && _isGameActive)
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.blue.shade900
                                  : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.blue.shade700
                                    : Colors.blue.shade300,
                              ),
                            ),
                            child: Text(
                              'Your Turn',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.blue.shade200
                                    : Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Game mode indicator
              if (_gameMode == GameMode.playerVsComputer)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF4E342E) // Darker brown for dark theme
                        : const Color(0xFFD2B48C), // Tan color to match wooden theme
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF5D4037) // Darker brown border
                          : const Color(0xFF8B4513), // SaddleBrown border
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Playing vs Computer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.amber.shade200 // Light color for dark theme
                          : const Color(0xFF654321), // Dark brown text
                    ),
                  ),
                ),

              // Game status display
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF4E342E) // Darker brown for dark theme
                      : const Color(0xFFF5DEB3), // Wheat color to match wooden theme
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.black).withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF5D4037) // Darker brown border
                        : const Color(0xFF8B4513), // SaddleBrown border
                    width: 1,
                  ),
                ),
                child: Text(
                  _getGameStatusText(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getStatusTextColor(),
                  ),
                ),
              ),

              // Game board
              GameBoard(
                game: _game,
                onSquarePressed: _makeMove,
                buttonSize: 80.0,
              ),

              const SizedBox(height: 30),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _resetGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF5D4037) // Darker brown for dark theme
                          : Colors.brown.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'New Game',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              
              // Instructor Chat (only if playing against computer and instructor is selected)
              if (_gameMode == GameMode.playerVsComputer)
                Consumer<InstructorProvider>(
                  builder: (context, instructorProvider, child) {
                    if (instructorProvider.currentInstructor != null) {
                      return const ChatWidget();
                    }
                    return const SizedBox.shrink();
                  },
                ),
            ],
          ), // Column
        ), // SingleChildScrollView
      ), // Container
    );
  }
}
