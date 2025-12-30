import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App title and logo
            Icon(
              Icons.tag_faces,
              size: 100,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.amber
                  : Colors.brown,
            ),
            const SizedBox(height: 30),
            Text(
              'XO Tic Tac Toe',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.amber.shade200
                    : Colors.brown.shade800,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'The Classic Game',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade300
                    : Colors.brown.shade600,
              ),
            ),
            const SizedBox(height: 60),
            
            // Game mode selection buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  // Player vs Player button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/game', arguments: 'player_vs_player');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF5D4037) // Darker brown for dark theme
                          : Colors.brown.shade600, // SaddleBrown for light theme
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, size: 24),
                        const SizedBox(width: 15),
                        Text(
                          '2 Players',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Player vs Computer button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/game', arguments: 'player_vs_computer');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF4E342E) // Even darker brown for dark theme
                          : Colors.brown.shade700, // Darker brown for light theme
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.computer, size: 24),
                        const SizedBox(width: 15),
                        Text(
                          'vs Computer',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Instructor Mode button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/instructor_selection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF3E2723) // Darkest brown
                          : Colors.brown.shade800, // Darkest brown
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school, size: 24),
                        const SizedBox(width: 15),
                        Text(
                          'Learn with Instructor',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // How to play button
                  OutlinedButton(
                    onPressed: () {
                      _showHowToPlayDialog(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.amber.shade700
                            : Colors.brown.shade600,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      'How to Play',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.amber.shade200
                            : Colors.brown.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHowToPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'How to Play',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.amber.shade200
                  : Colors.brown.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' The game is played on a 3x3 grid',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade300
                      : Colors.brown.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ' Player X goes first',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade300
                      : Colors.brown.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ' Players take turns placing X and O marks',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade300
                      : Colors.brown.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ' The first player to get 3 of their marks in a row (up, down, across, or diagonally) wins',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade300
                      : Colors.brown.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ' When all 9 squares are full, the game is over. If no player has 3 marks in a row, the game ends in a draw',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade300
                      : Colors.brown.shade700,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Got it!',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.amber.shade200
                      : Colors.brown.shade600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
