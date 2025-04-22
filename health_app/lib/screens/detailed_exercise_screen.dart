import 'package:flutter/material.dart';
import '../widgets/exercise_renderer.dart';
import '../data/cbt_exercise.dart';
import '../data/user_stats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailedExerciseScreen extends StatefulWidget {
  final String exerciseJsonPath;
  final String exerciseTitle;
  final String exerciseType;

  const DetailedExerciseScreen({
    Key? key,
    required this.exerciseJsonPath,
    required this.exerciseTitle,
    required this.exerciseType,
  }) : super(key: key);

  @override
  State<DetailedExerciseScreen> createState() => _DetailedExerciseScreenState();
}

class _DetailedExerciseScreenState extends State<DetailedExerciseScreen> {
  bool _showBottomNavBar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ExerciseRenderer(
        exerciseJsonPath: widget.exerciseJsonPath,
        onComplete: (responses) {
          // Handle the completion
          _showCompletionDialog(context, responses);
        },
      ),
      // Hide bottom navigation bar for this screen
      bottomNavigationBar: _showBottomNavBar
          ? Theme(
              data: Theme.of(context),
              child: BottomNavigationBar(
                currentIndex: 0, // Doesn't matter which index is selected here
                onTap: (_) {},
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.lightbulb_outline),
                    activeIcon: Icon(Icons.lightbulb),
                    label: 'CBT',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.edit_note_outlined),
                    activeIcon: Icon(Icons.edit_note),
                    label: 'Thoughts',
                  ),
                ],
              ),
            )
          : null,
    );
  }

  void _showCompletionDialog(
      BuildContext context, Map<String, dynamic> responses) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exercise Completed"),
        content: const Text("Congratulations! You've completed this exercise."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
          ElevatedButton(
            onPressed: () {
              // Save responses and navigate back
              _saveExerciseCompletion(context, responses);
              Navigator.of(context).pop();
              Navigator.of(context).pop(responses);
            },
            child: const Text("Save & Exit"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveExerciseCompletion(
      BuildContext context, Map<String, dynamic> responses) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to save your progress")),
      );
      return;
    }

    try {
      // Create a summary of the user's responses
      String responsesSummary = _createResponsesSummary(responses);

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cbt_exercises')
          .add({
        'title': widget.exerciseTitle,
        'type': widget.exerciseType,
        'completedDate': FieldValue.serverTimestamp(),
        'notes': responsesSummary,
      });

      // Update stats
      final statsService = UserStatsService();
      await statsService.logCBTExercise(
        title: widget.exerciseTitle,
        exerciseType: widget.exerciseType,
        notes: "Completed interactive exercise",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Progress saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving progress: $e")),
      );
    }
  }

  String _createResponsesSummary(Map<String, dynamic> responses) {
    // Create a basic summary of responses
    // In a real app, this would be more sophisticated
    return "Completed ${responses.length} question(s)";
  }
}
