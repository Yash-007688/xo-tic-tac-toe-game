import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/instructor_selection_screen.dart';
import 'providers/instructor_provider.dart';

void main() {
  runApp(const XOTicTacToeApp());
}

class XOTicTacToeApp extends StatelessWidget {
  const XOTicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => InstructorProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'XO Tic Tac Toe',
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              primarySwatch: Colors.brown,
              scaffoldBackgroundColor: Colors.brown.shade50,
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF8B4513),
                foregroundColor: Colors.white,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              primarySwatch: Colors.grey,
              scaffoldBackgroundColor: Colors.grey.shade900,
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF3E2723),
                foregroundColor: Colors.white,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D4037),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const WelcomeScreen(),
              '/game': (context) {
                final String? gameMode = ModalRoute.of(context)?.settings.arguments as String?;
                return GameScreen(gameMode: gameMode);
              },
              '/settings': (context) => const SettingsScreen(),
              '/instructor_selection': (context) => const InstructorSelectionScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
