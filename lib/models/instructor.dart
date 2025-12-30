import 'package:flutter/material.dart';

enum InstructorLevel { beginner, medium, pro }

class Instructor {
  final String id;
  final String name;
  final InstructorLevel level;
  final String bio;
  final String specialization;
  final String avatarAsset; // Path to image asset, or use icon for now
  final Color color;

  Instructor({
    required this.id,
    required this.name,
    required this.level,
    required this.bio,
    required this.specialization,
    this.avatarAsset = 'assets/instructors/default.png', 
    required this.color,
  });
}

class ChatMessage {
  final String text;
  final bool isUser; // true if sent by user, false if by instructor
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
