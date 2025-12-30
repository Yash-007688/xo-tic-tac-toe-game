import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/instructor_provider.dart';
import '../models/instructor.dart';

class InstructorSelectionScreen extends StatelessWidget {
  const InstructorSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Instructor'),
      ),
      body: Consumer<InstructorProvider>(
        builder: (context, provider, child) {
          final instructors = provider.instructors;
          
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: instructors.length,
            itemBuilder: (context, index) {
              final instructor = instructors[index];
              final isUnlocked = provider.isInstructorUnlocked(instructor.id);
              
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                color: isUnlocked ? instructor.color : Colors.grey.shade400,
                child: InkWell(
                  onTap: isUnlocked
                      ? () {
                          provider.selectInstructor(instructor);
                          // Navigate to game screen with computer mode
                          Navigator.pushNamed(
                            context, 
                            '/game', 
                            arguments: 'player_vs_computer'
                          );
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Text(
                            instructor.name[0],
                            style: TextStyle(
                              fontSize: 24, 
                              fontWeight: FontWeight.bold,
                              color: instructor.color
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                instructor.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${instructor.level.name.toUpperCase()} • ${instructor.specialization}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                instructor.bio,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        if (!isUnlocked)
                          const Icon(Icons.lock, color: Colors.white, size: 30),
                        if (isUnlocked)
                          const Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
