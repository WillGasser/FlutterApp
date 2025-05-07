import 'package:flutter/services.dart';
import 'dart:convert';
import '../data/detailed_cbt_exercise.dart';

class ExerciseService {
  // List of available exercises with their paths
  static final List<Map<String, String>> availableExercises = [
    // Core exercises
    {
      'id': 'cbt001',
      'title': 'Introduction to CBT Concepts',
      'path': 'assets/exercises/cbt_basics.json',
      'type': 'cbt_basics'
    },
    {
      'id': 'cd001',
      'title': 'Identifying Cognitive Distortions',
      'path': 'assets/exercises/identifying_cognitive_distortions.json',
      'type': 'cognitive_restructuring'
    },
    {
      'id': 'tr001',
      'title': 'CBT Thought Record',
      'path': 'assets/exercises/thought_record.json',
      'type': 'thought_record'
    },

    // Specialized modules
    {
      'id': 'anx001',
      'title': 'Managing Anxiety with CBT',
      'path': 'assets/exercises/managing_anxiety.json',
      'type': 'anxiety_management'
    },
    {
      'id': 'sm001',
      'title': 'Stress Management Techniques',
      'path': 'assets/exercises/stress_management.json',
      'type': 'stress_management'
    },
    {
      'id': 'ba001',
      'title': 'Behavior Activation Plan',
      'path': 'assets/exercises/behavior_activation.json',
      'type': 'behavior_activation'
    },

    // Advanced modules
    {
      'id': 'cb001',
      'title': 'Challenging Negative Core Beliefs',
      'path': 'assets/exercises/challenging_beliefs.json',
      'type': 'core_beliefs'
    },
    {
      'id': 'mf001',
      'title': 'Mindfulness for Stress Reduction',
      'path': 'assets/exercises/mindfulness_exercise.json',
      'type': 'mindfulness'
    },
    {
      'id': 'sc001',
      'title': 'Developing Self-Compassion',
      'path': 'assets/exercises/self_compassion.json',
      'type': 'self_compassion'
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

  // Get exercise sequence (learning path)
  static List<Map<String, dynamic>> getLearningPath() {
    return [
      {
        'id': 'cbt001',
        'title': 'Introduction to CBT Concepts',
        'type': 'cbt_basics',
        'description': 'Learn the foundational concepts of CBT',
        'order': 1,
        'prerequisites': []
      },
      {
        'id': 'cd001',
        'title': 'Identifying Cognitive Distortions',
        'type': 'cognitive_restructuring',
        'description': 'Learn to identify common thinking traps',
        'order': 2,
        'prerequisites': ['cbt001']
      },
      {
        'id': 'tr001',
        'title': 'CBT Thought Record',
        'type': 'thought_record',
        'description': 'Practice analyzing and reframing thoughts',
        'order': 3,
        'prerequisites': ['cd001']
      },
      {
        'id': 'sm001',
        'title': 'Stress Management Techniques',
        'type': 'stress_management',
        'description': 'Learn effective strategies to manage stress',
        'order': 4,
        'prerequisites': ['tr001']
      },
      {
        'id': 'anx001',
        'title': 'Managing Anxiety with CBT',
        'type': 'anxiety_management',
        'description': 'Apply CBT techniques to reduce anxiety',
        'order': 5,
        'prerequisites': ['sm001']
      },
      {
        'id': 'mf001',
        'title': 'Mindfulness for Stress Reduction',
        'type': 'mindfulness',
        'description': 'Practice mindfulness techniques',
        'order': 6,
        'prerequisites': ['sm001']
      },
      {
        'id': 'ba001',
        'title': 'Behavior Activation Plan',
        'type': 'behavior_activation',
        'description': 'Create a plan to engage in rewarding activities',
        'order': 7,
        'prerequisites': ['anx001', 'mf001']
      },
      {
        'id': 'cb001',
        'title': 'Challenging Negative Core Beliefs',
        'type': 'core_beliefs',
        'description': 'Address deeper beliefs that influence thoughts',
        'order': 8,
        'prerequisites': ['tr001', 'ba001']
      },
      {
        'id': 'sc001',
        'title': 'Developing Self-Compassion',
        'type': 'self_compassion',
        'description': 'Learn to treat yourself with kindness',
        'order': 9,
        'prerequisites': ['cb001']
      }
    ];
  }

  // Helper function to determine if an exercise should be unlocked based on completed exercises
  static bool isExerciseUnlocked(
      String exerciseId, List<String> completedExerciseIds) {
    // The first exercise is always unlocked
    final learningPath = getLearningPath();
    final exerciseInfo = learningPath.firstWhere(
      (exercise) => exercise['id'] == exerciseId,
      orElse: () => {'prerequisites': []},
    );

    final prerequisites = exerciseInfo['prerequisites'] as List<dynamic>? ?? [];

    // Exercise is unlocked if it has no prerequisites or all prerequisites are completed
    return prerequisites.isEmpty ||
        prerequisites.every((prereq) => completedExerciseIds.contains(prereq));
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
