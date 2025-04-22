import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/detailed_cbt_exercise.dart';

class ExerciseRenderer extends StatefulWidget {
  final String exerciseJsonPath;
  final Function(Map<String, dynamic>)? onComplete;

  const ExerciseRenderer({
    Key? key,
    required this.exerciseJsonPath,
    this.onComplete,
  }) : super(key: key);

  @override
  State<ExerciseRenderer> createState() => _ExerciseRendererState();
}

class _ExerciseRendererState extends State<ExerciseRenderer> {
  DetailedCBTExercise? _exercise;
  bool _isLoading = true;
  int _currentQuestionIndex = 0;
  final Map<String, dynamic> _userResponses = {};
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadExercise();
  }

  Future<void> _loadExercise() async {
    try {
      // Load the JSON file from assets
      final String jsonString =
          await rootBundle.loadString(widget.exerciseJsonPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Parse into our model
      final exercise = DetailedCBTExercise.fromJson(jsonData);

      setState(() {
        _exercise = exercise;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading exercise: $e');
    }
  }

  void _saveResponse(String questionId, dynamic response) {
    setState(() {
      _userResponses[questionId] = response;
    });
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < (_exercise?.questions.length ?? 0) - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _pageController.animateToPage(
        _currentQuestionIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Exercise complete
      if (widget.onComplete != null) {
        widget.onComplete!(_userResponses);
      }
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
      _pageController.animateToPage(
        _currentQuestionIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_exercise == null) {
      return const Center(child: Text('Failed to load exercise'));
    }

    return Column(
      children: [
        // Exercise header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _exercise!.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _exercise!.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value:
                    (_currentQuestionIndex + 1) / _exercise!.questions.length,
              ),
              const SizedBox(height: 8),
              Text(
                'Question ${_currentQuestionIndex + 1} of ${_exercise!.questions.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        // Questions
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _exercise!.questions.length,
            onPageChanged: (index) {
              setState(() {
                _currentQuestionIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final question = _exercise!.questions[index];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: _buildQuestionWidget(question),
              );
            },
          ),
        ),

        // Navigation buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentQuestionIndex > 0)
                ElevatedButton(
                  onPressed: _goToPreviousQuestion,
                  child: const Text('Previous'),
                )
              else
                const SizedBox(width: 80),
              Text(
                '${_currentQuestionIndex + 1}/${_exercise!.questions.length}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              ElevatedButton(
                onPressed: _goToNextQuestion,
                child: Text(
                    _currentQuestionIndex < _exercise!.questions.length - 1
                        ? 'Next'
                        : 'Complete'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionWidget(ExerciseQuestion question) {
    switch (question.type) {
      case 'multiple_choice':
        return _buildMultipleChoiceQuestion(question as MultipleChoiceQuestion);
      case 'text_response':
        return _buildTextResponseQuestion(question as TextResponseQuestion);
      case 'scale':
        return _buildScaleQuestion(question as ScaleQuestion);
      case 'true_false':
        return _buildTrueFalseQuestion(question as TrueFalseQuestion);
      case 'image_response':
        return _buildImageResponseQuestion(question as ImageResponseQuestion);
      default:
        return Text('Unsupported question type: ${question.type}');
    }
  }

  Widget _buildMultipleChoiceQuestion(MultipleChoiceQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.prompt,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        ...List.generate(
          question.options.length,
          (index) => RadioListTile<int>(
            title: Text(question.options[index]),
            value: index,
            groupValue: _userResponses[question.id] as int?,
            onChanged: (value) {
              _saveResponse(question.id, value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextResponseQuestion(TextResponseQuestion question) {
    // Create a text controller if it doesn't exist
    final textController = TextEditingController(
      text: _userResponses[question.id] as String? ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.prompt,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: textController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: question.placeholder,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            _saveResponse(question.id, value);
          },
        ),
      ],
    );
  }

  Widget _buildScaleQuestion(ScaleQuestion question) {
    double value = (_userResponses[question.id] as double?) ??
        (question.min + (question.max - question.min) / 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.prompt,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        Slider(
          value: value,
          min: question.min.toDouble(),
          max: question.max.toDouble(),
          divisions: question.max - question.min,
          label: value.round().toString(),
          onChanged: (newValue) {
            setState(() {
              _saveResponse(question.id, newValue);
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(question.minLabel ?? question.min.toString()),
              Text(question.maxLabel ?? question.max.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrueFalseQuestion(TrueFalseQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.prompt,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        RadioListTile<bool>(
          title: const Text('True'),
          value: true,
          groupValue: _userResponses[question.id] as bool?,
          onChanged: (value) {
            _saveResponse(question.id, value);
          },
        ),
        RadioListTile<bool>(
          title: const Text('False'),
          value: false,
          groupValue: _userResponses[question.id] as bool?,
          onChanged: (value) {
            _saveResponse(question.id, value);
          },
        ),
      ],
    );
  }

  Widget _buildImageResponseQuestion(ImageResponseQuestion question) {
    // Create a text controller if it doesn't exist
    final textController = TextEditingController(
      text: _userResponses[question.id] as String? ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.prompt,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        // In a real app, you'd handle images better
        Image.asset(
          question.imageUrl,
          height: 200,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: textController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: question.placeholder,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            _saveResponse(question.id, value);
          },
        ),
      ],
    );
  }
}
