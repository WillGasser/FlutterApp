import 'package:flutter/material.dart';
import '../widgets/exercise_renderer.dart';
import '../data/cbt_exercise.dart';
import '../data/user_stats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailedExerciseScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ExerciseRenderer(
        exerciseJsonPath: exerciseJsonPath,
        onComplete: (responses) {
          // Handle the completion
          _showCompletionDialog(context, responses);
        },
      ),
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
        'title': exerciseTitle,
        'type': exerciseType,
        'completedDate': FieldValue.serverTimestamp(),
        'notes': responsesSummary,
      });

      // Update stats
      final statsService = UserStatsService();
      await statsService.logCBTExercise(
        title: exerciseTitle,
        exerciseType: exerciseType,
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
