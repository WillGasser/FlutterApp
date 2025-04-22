import 'dart:convert';

// Main class to represent a detailed CBT exercise
class DetailedCBTExercise {
  final String id;
  final String title;
  final String description;
  final String type;
  final int durationMinutes;
  final List<ExerciseQuestion> questions;

  DetailedCBTExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.durationMinutes,
    required this.questions,
  });

  // Parse from JSON
  factory DetailedCBTExercise.fromJson(Map<String, dynamic> json) {
    List<ExerciseQuestion> questionList = [];

    if (json['questions'] != null) {
      for (var q in json['questions']) {
        questionList.add(ExerciseQuestion.fromJson(q));
      }
    }

    return DetailedCBTExercise(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      durationMinutes: json['durationMinutes'],
      questions: questionList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'durationMinutes': durationMinutes,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

// Base class for all question types
abstract class ExerciseQuestion {
  final String id;
  final String type;
  final String prompt;

  ExerciseQuestion({
    required this.id,
    required this.type,
    required this.prompt,
  });

  // Factory constructor to create the appropriate question type
  factory ExerciseQuestion.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'multiple_choice':
        return MultipleChoiceQuestion.fromJson(json);
      case 'text_response':
        return TextResponseQuestion.fromJson(json);
      case 'scale':
        return ScaleQuestion.fromJson(json);
      case 'true_false':
        return TrueFalseQuestion.fromJson(json);
      case 'image_response':
        return ImageResponseQuestion.fromJson(json);
      default:
        throw Exception('Unknown question type: ${json['type']}');
    }
  }

  Map<String, dynamic> toJson();
}

// Multiple choice question
class MultipleChoiceQuestion extends ExerciseQuestion {
  final List<String> options;
  final int? correctAnswer; // Optional, may be null for non-quiz questions

  MultipleChoiceQuestion({
    required super.id,
    required super.prompt,
    required this.options,
    this.correctAnswer,
  }) : super(type: 'multiple_choice');

  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceQuestion(
      id: json['id'],
      prompt: json['prompt'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'prompt': prompt,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }
}

// Text response question
class TextResponseQuestion extends ExerciseQuestion {
  final String? placeholder;

  TextResponseQuestion({
    required super.id,
    required super.prompt,
    this.placeholder,
  }) : super(type: 'text_response');

  factory TextResponseQuestion.fromJson(Map<String, dynamic> json) {
    return TextResponseQuestion(
      id: json['id'],
      prompt: json['prompt'],
      placeholder: json['placeholder'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'prompt': prompt,
      'placeholder': placeholder,
    };
  }
}

// Scale question (slider)
class ScaleQuestion extends ExerciseQuestion {
  final int min;
  final int max;
  final String? minLabel;
  final String? maxLabel;

  ScaleQuestion({
    required super.id,
    required super.prompt,
    required this.min,
    required this.max,
    this.minLabel,
    this.maxLabel,
  }) : super(type: 'scale');

  factory ScaleQuestion.fromJson(Map<String, dynamic> json) {
    return ScaleQuestion(
      id: json['id'],
      prompt: json['prompt'],
      min: json['min'],
      max: json['max'],
      minLabel: json['minLabel'],
      maxLabel: json['maxLabel'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'prompt': prompt,
      'min': min,
      'max': max,
      'minLabel': minLabel,
      'maxLabel': maxLabel,
    };
  }
}

// True/False question
class TrueFalseQuestion extends ExerciseQuestion {
  final bool? correctAnswer; // Optional, may be null for non-quiz questions

  TrueFalseQuestion({
    required super.id,
    required super.prompt,
    this.correctAnswer,
  }) : super(type: 'true_false');

  factory TrueFalseQuestion.fromJson(Map<String, dynamic> json) {
    return TrueFalseQuestion(
      id: json['id'],
      prompt: json['prompt'],
      correctAnswer: json['correctAnswer'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'prompt': prompt,
      'correctAnswer': correctAnswer,
    };
  }
}

// Image response question
class ImageResponseQuestion extends ExerciseQuestion {
  final String imageUrl;
  final String? placeholder;

  ImageResponseQuestion({
    required super.id,
    required super.prompt,
    required this.imageUrl,
    this.placeholder,
  }) : super(type: 'image_response');

  factory ImageResponseQuestion.fromJson(Map<String, dynamic> json) {
    return ImageResponseQuestion(
      id: json['id'],
      prompt: json['prompt'],
      imageUrl: json['imageUrl'],
      placeholder: json['placeholder'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'prompt': prompt,
      'imageUrl': imageUrl,
      'placeholder': placeholder,
    };
  }
}
