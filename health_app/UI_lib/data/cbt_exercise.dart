import 'package:cloud_firestore/cloud_firestore.dart';

class CBTExercise {
  final String id;
  final String title;
  final String description;
  final String type;
  final int durationMinutes;
  final DateTime? completedDate;
  final String? notes;

  CBTExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.durationMinutes,
    this.completedDate,
    this.notes,
  });

  // Factory constructor to create a CBTExercise from Firestore data
  factory CBTExercise.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CBTExercise(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? 'general',
      durationMinutes: data['durationMinutes'] ?? 10,
      completedDate: (data['completedDate'] as Timestamp?)?.toDate(),
      notes: data['notes'],
    );
  }

  // Convert to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'durationMinutes': durationMinutes,
      'completedDate':
          completedDate != null ? Timestamp.fromDate(completedDate!) : null,
      'notes': notes,
    };
  }

  // Create a copy with updated fields
  CBTExercise copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    int? durationMinutes,
    DateTime? completedDate,
    String? notes,
  }) {
    return CBTExercise(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      completedDate: completedDate ?? this.completedDate,
      notes: notes ?? this.notes,
    );
  }
}

// Define exercise types for consistency
class CBTExerciseType {
  static const String thoughtRecord = 'thought_record';
  static const String behaviorActivation = 'behavior_activation';
  static const String cognitiveRestructuring = 'cognitive_restructuring';
  static const String exposureExercise = 'exposure_exercise';
  static const String mindfulness = 'mindfulness';
  static const String quiz = 'quiz';
  static const String general = 'general';

  // Available exercise types as a list
  static List<String> get all => [
        thoughtRecord,
        behaviorActivation,
        cognitiveRestructuring,
        exposureExercise,
        mindfulness,
        quiz,
        general,
      ];

  // Get display name for an exercise type
  static String getDisplayName(String type) {
    switch (type) {
      case thoughtRecord:
        return 'Thought Record';
      case behaviorActivation:
        return 'Behavior Activation';
      case cognitiveRestructuring:
        return 'Cognitive Restructuring';
      case exposureExercise:
        return 'Exposure Exercise';
      case mindfulness:
        return 'Mindfulness';
      case quiz:
        return 'Quiz';
      case general:
        return 'General Exercise';
      default:
        return 'Unknown Exercise';
    }
  }
}
