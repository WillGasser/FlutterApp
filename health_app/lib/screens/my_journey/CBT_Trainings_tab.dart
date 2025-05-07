import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../theme.dart';
import '../../data/cbt_exercise.dart';

class CBTTrainingsTab extends StatefulWidget {
  const CBTTrainingsTab({Key? key}) : super(key: key);

  @override
  State<CBTTrainingsTab> createState() => _CBTTrainingsTabState();
}

class _CBTTrainingsTabState extends State<CBTTrainingsTab> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _completedExercises = [];

  @override
  void initState() {
    super.initState();
    _fetchCompletedExercises();
  }

  Future<void> _fetchCompletedExercises() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle guest user case
        setState(() {
          _completedExercises = [];
          _isLoading = false;
        });
        return;
      }

      // Get user's completed exercises
      final exercisesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('completed_cbt_exercises')
          .orderBy('completedDate', descending: true)
          .get();

      final exercises = exercisesSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'exerciseId': data['exerciseId'] ?? '',
          'exerciseTitle': data['exerciseTitle'] ?? 'Unknown Exercise',
          'completedDate': data['completedDate'] ?? Timestamp.now(),
          'score': data['score'],
          'responses': data['responses'] ?? {},
        };
      }).toList();

      if (mounted) {
        setState(() {
          _completedExercises = exercises;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching completed exercises: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;

          // For testing purposes, add some mock data if Firestore fetch fails
          if (_completedExercises.isEmpty) {
            _completedExercises = [
              {
                'id': 'mock-1',
                'exerciseId': 'thought_record',
                'exerciseTitle': 'Thought Record',
                'completedDate': Timestamp.fromDate(
                  DateTime.now().subtract(const Duration(days: 1)),
                ),
                'score': 85,
              },
              {
                'id': 'mock-2',
                'exerciseId': 'cbt_basics',
                'exerciseTitle': 'CBT Basics',
                'completedDate': Timestamp.fromDate(
                  DateTime.now().subtract(const Duration(days: 3)),
                ),
                'score': 92,
              },
              {
                'id': 'mock-3',
                'exerciseId': 'mindfulness_exercise',
                'exerciseTitle': 'Mindfulness Exercise',
                'completedDate': Timestamp.fromDate(
                  DateTime.now().subtract(const Duration(days: 5)),
                ),
                'score': 78,
              },
            ];
          }
        });
      }
    }
  }

  String _formatDate(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return DateFormat('MMMM d, yyyy').format(dateTime);
  }

  Color _getScoreColor(int? score) {
    if (score == null) return Colors.grey;
    if (score >= 90) return Colors.green;
    if (score >= 75) return Colors.amber[700]!;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreMessage(int? score) {
    if (score == null) return "Not scored";
    if (score >= 90) return "Excellent";
    if (score >= 75) return "Good job";
    if (score >= 60) return "Keep practicing";
    return "Needs improvement";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      );
    }

    if (_completedExercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: isDark ? Colors.grey[700] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No completed CBT exercises yet',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Complete CBT exercises to see them here',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.psychology),
              label: const Text('Start CBT Exercise'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchCompletedExercises,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _completedExercises.length,
        itemBuilder: (context, index) {
          final exercise = _completedExercises[index];
          final title = exercise['exerciseTitle'] as String;
          final date = exercise['completedDate'] as Timestamp;
          final score = exercise['score'] as int?;

          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark
                    ? ThemeProvider.darkDividerColor
                    : ThemeProvider.lightDividerColor,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.psychology,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(date),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (score != null)
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _getScoreColor(score).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$score',
                              style: TextStyle(
                                color: _getScoreColor(score),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getScoreMessage(score),
                        style: TextStyle(
                          color: _getScoreColor(score),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // View details implementation would go here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Exercise details coming soon!'),
                            ),
                          );
                        },
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
