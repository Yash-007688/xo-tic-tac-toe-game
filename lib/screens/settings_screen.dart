import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../models/computer_player.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF3E2723) // Dark brown for dark theme
            : Colors.brown.shade600, // Light brown for light theme
        foregroundColor: Colors.white,
        elevation: 0,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Settings
              Card(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF4E342E) // Darker brown for dark theme
                    : const Color(0xFFF5DEB3), // Wheat color for light theme
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF5D4037) // Darker brown border
                        : const Color(0xFF8B4513), // SaddleBrown border
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.amber.shade200
                              : Colors.brown.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Provider.of<ThemeProvider>(context).isDarkTheme
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.amber
                                : Colors.brown,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            Provider.of<ThemeProvider>(context).isDarkTheme
                                ? 'Dark Mode'
                                : 'Light Mode',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: Provider.of<ThemeProvider>(context).isDarkTheme,
                            onChanged: (bool value) {
                              Provider.of<ThemeProvider>(context, listen: false).setDarkTheme(value);
                            },
                            activeColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.amber
                                : Colors.brown,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Computer Difficulty Settings
              Card(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF4E342E) // Darker brown for dark theme
                    : const Color(0xFFF5DEB3), // Wheat color for light theme
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF5D4037) // Darker brown border
                        : const Color(0xFF8B4513), // SaddleBrown border
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Computer Difficulty',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.amber.shade200
                              : Colors.brown.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select computer difficulty level:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade300
                              : Colors.brown.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          RadioListTile<DifficultyLevel>(
                            title: Text(
                              'Easy',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            value: DifficultyLevel.easy,
                            groupValue: XOComputerPlayer.currentDifficulty,
                            onChanged: (DifficultyLevel? value) {
                              if (value != null) {
                                XOComputerPlayer.currentDifficulty = value;
                              }
                            },
                            activeColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.amber
                                : Colors.brown,
                            tileColor: Colors.transparent,
                          ),
                          RadioListTile<DifficultyLevel>(
                            title: Text(
                              'Medium',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            value: DifficultyLevel.medium,
                            groupValue: XOComputerPlayer.currentDifficulty,
                            onChanged: (DifficultyLevel? value) {
                              if (value != null) {
                                XOComputerPlayer.currentDifficulty = value;
                              }
                            },
                            activeColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.amber
                                : Colors.brown,
                            tileColor: Colors.transparent,
                          ),
                          RadioListTile<DifficultyLevel>(
                            title: Text(
                              'Tough',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            value: DifficultyLevel.tough,
                            groupValue: XOComputerPlayer.currentDifficulty,
                            onChanged: (DifficultyLevel? value) {
                              if (value != null) {
                                XOComputerPlayer.currentDifficulty = value;
                              }
                            },
                            activeColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.amber
                                : Colors.brown,
                            tileColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
