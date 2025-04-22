import 'package:flutter/services.dart';
import 'dart:convert';
import '../data/detailed_cbt_exercise.dart';

class ExerciseService {
  // List of available exercises with their paths
  static final List<Map<String, String>> availableExercises = [
    {
      'id': 'cd001',
      'title': 'Identifying Cognitive Distortions',
      'path': 'assets/exercises/identifying_cognitive_distortions.json',
      'type': 'cognitive_restructuring'
    },
    {
      'id': 'anx001',
      'title': 'Managing Anxiety with CBT',
      'path': 'assets/exercises/managing_anxiety.json',
      'type': 'anxiety_management'
    },
    {
      'id': 'ba001',
      'title': 'Behavior Activation Plan',
      'path': 'assets/exercises/behavior_activation.json',
      'type': 'behavior_activation'
    }
  ];

  // Get the list of available exercises
  static List<Map<String, String>> getAvailableExercises() {
    return availableExercises;
  }

  // Load a specific exercise by ID
  static Future<DetailedCBTExercise?> loadExerciseById(String id) async {
    final exerciseInfo = availableExercises.firstWhere(
      (exercise) => exercise['id'] == id,
      orElse: () => {'id': '', 'title': '', 'path': '', 'type': ''},
    );

    if (exerciseInfo['path']!.isEmpty) {
      return null;
    }

    try {
      final jsonString = await rootBundle.loadString(exerciseInfo['path']!);
      final jsonData = json.decode(jsonString);
      return DetailedCBTExercise.fromJson(jsonData);
    } catch (e) {
      print('Error loading exercise $id: $e');
      return null;
    }
  }

  // In the future, this would save responses to Firebase
  static Future<bool> saveExerciseResponses(
      String exerciseId, Map<String, dynamic> responses) async {
    // This is where you would save to Firebase
    // For now, just log the responses
    print('Saved responses for exercise $exerciseId: $responses');
    return true;
  }
}
