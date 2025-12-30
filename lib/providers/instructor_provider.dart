import 'package:flutter/material.dart';
import '../models/instructor.dart';
import '../models/game_state.dart';
import '../models/computer_player.dart';

class InstructorProvider with ChangeNotifier {
  // Hardcoded list of instructors
  final List<Instructor> _instructors = [
    // Beginner Instructors
    Instructor(
      id: 'beg_1',
      name: 'Alice',
      level: InstructorLevel.beginner,
      bio: 'Patient teacher. Focuses on basic strategies.',
      specialization: 'Basic Tactics',
      color: Colors.green.shade300,
    ),
    Instructor(
      id: 'beg_2',
      name: 'Bob',
      level: InstructorLevel.beginner,
      bio: 'Loves teaching fundamentals.',
      specialization: 'Fundamentals',
      color: Colors.green.shade400,
    ),
    Instructor(
      id: 'beg_3',
      name: 'Carol',
      level: InstructorLevel.beginner,
      bio: 'Great for learning the basics.',
      specialization: 'Basic Moves',
      color: Colors.green.shade500,
    ),
    
    // Medium Instructors
    Instructor(
      id: 'med_1',
      name: 'Marcus',
      level: InstructorLevel.medium,
      bio: 'Strategic thinker. Focuses on controlling the center.',
      specialization: 'Center Control',
      color: Colors.orange.shade300,
    ),
    Instructor(
      id: 'med_2',
      name: 'Elena',
      level: InstructorLevel.medium,
      bio: 'Expert in setting up traps.',
      specialization: 'Traps',
      color: Colors.orange.shade400,
    ),
    Instructor(
      id: 'med_3',
      name: 'David',
      level: InstructorLevel.medium,
      bio: 'Analyzes opponent patterns.',
      specialization: 'Pattern Recognition',
      color: Colors.orange.shade500,
    ),
    Instructor(
      id: 'med_4',
      name: 'Sophie',
      level: InstructorLevel.medium,
      bio: 'Teaches double attacks.',
      specialization: 'Forks',
      color: Colors.orange.shade600,
    ),

    // Pro Instructors
    Instructor(
      id: 'pro_1',
      name: 'Grandmaster Chen',
      level: InstructorLevel.pro,
      bio: 'Unbeatable. Knows every possible game state.',
      specialization: 'Perfect Play',
      color: Colors.red.shade300,
    ),
    Instructor(
      id: 'pro_2',
      name: 'AI-X',
      level: InstructorLevel.pro,
      bio: 'Pure logic. Calculates 10 moves ahead.',
      specialization: 'Deep Calculation',
      color: Colors.red.shade400,
    ),
    Instructor(
      id: 'pro_3',
      name: 'Viktor',
      level: InstructorLevel.pro,
      bio: 'Aggressive and uncompromising.',
      specialization: 'Aggression',
      color: Colors.red.shade500,
    ),
  ];

  Instructor? _currentInstructor;
  final List<String> _unlockedInstructorIds = ['beg_1', 'beg_2', 'beg_3']; // Start with beginners unlocked
  final List<ChatMessage> _chatHistory = [];

  List<Instructor> get instructors => _instructors;
  Instructor? get currentInstructor => _currentInstructor;
  List<ChatMessage> get chatHistory => _chatHistory;

  void selectInstructor(Instructor instructor) {
    if (isInstructorUnlocked(instructor.id)) {
      _currentInstructor = instructor;
      _chatHistory.clear();
      _addSystemMessage('Hi! I\'m . Let\'s play some Tic Tac Toe!');
      
      // Set game difficulty based on instructor level
      switch (instructor.level) {
        case InstructorLevel.beginner:
          XOComputerPlayer.currentDifficulty = DifficultyLevel.easy;
          break;
        case InstructorLevel.medium:
          XOComputerPlayer.currentDifficulty = DifficultyLevel.medium;
          break;
        case InstructorLevel.pro:
          XOComputerPlayer.currentDifficulty = DifficultyLevel.tough;
          break;
      }
      
      notifyListeners();
    }
  }

  bool isInstructorUnlocked(String id) {
    return _unlockedInstructorIds.contains(id);
  }

  void _addSystemMessage(String text) {
    _chatHistory.add(ChatMessage(
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  void addUserMessage(String text) {
    _chatHistory.add(ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
    
    // Simple response logic for now
    Future.delayed(const Duration(seconds: 1), () {
      _addSystemMessage('That\'s an interesting question! I\'m focusing on the game right now.');
    });
  }

  // Called when game state changes
  void onGameEvent(GameStatus status, Player currentPlayer) {
    if (_currentInstructor == null) return;

    if (status == GameStatus.xWins) {
      _addSystemMessage('Great job! You won! ');
      _checkProgression();
    } else if (status == GameStatus.oWins) {
      _addSystemMessage('Good try! Watch out for my traps next time.');
    } else if (status == GameStatus.draw) {
      _addSystemMessage('It\'s a draw! Well played.');
    }
  }

  void _checkProgression() {
    // Simple progression: unlock next level instructors if not already unlocked
    // Real logic would be more complex (e.g. win 3 games against current level)
    
    // For demo: unlock all mediums if beating a beginner
    if (_currentInstructor!.level == InstructorLevel.beginner) {
       bool anyMediumLocked = _instructors
           .where((i) => i.level == InstructorLevel.medium)
           .any((i) => !_unlockedInstructorIds.contains(i.id));
           
       if (anyMediumLocked) {
         _unlockedInstructorIds.addAll(
             _instructors
                 .where((i) => i.level == InstructorLevel.medium)
                 .map((i) => i.id)
         );
         _addSystemMessage('Congratulations! You\'ve unlocked Medium level instructors!');
         notifyListeners();
       }
    }
    // Unlock pros if beating a medium
    else if (_currentInstructor!.level == InstructorLevel.medium) {
       bool anyProLocked = _instructors
           .where((i) => i.level == InstructorLevel.pro)
           .any((i) => !_unlockedInstructorIds.contains(i.id));
           
       if (anyProLocked) {
         _unlockedInstructorIds.addAll(
             _instructors
                 .where((i) => i.level == InstructorLevel.pro)
                 .map((i) => i.id)
         );
         _addSystemMessage('Amazing! You\'ve unlocked Pro level instructors!');
         notifyListeners();
       }
    }
  }
}
