import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/user_stats.dart';

/// This screen implements a 1-minute thought log where the timer starts on
/// the first keystroke. When the user taps "Complete", the log is submitted
/// and the text field is reset.
class ThoughtLogScreen extends StatefulWidget {
  const ThoughtLogScreen({Key? key}) : super(key: key);

  @override
  State<ThoughtLogScreen> createState() => _ThoughtLogScreenState();
}

class _ThoughtLogScreenState extends State<ThoughtLogScreen> {
  // Whether the timer has started.
  bool _isStarted = false;
  // Whether the timer has completed (i.e. reached 0 seconds).
  bool _isCompleted = false;
  // Seconds remaining for the countdown.
  int _timeRemaining = 60;
  Timer? _timer;
  bool _isSaving = false;

  // Controller for the text field.
  final TextEditingController _textController = TextEditingController();
  final UserStatsService _statsService = UserStatsService();

  /// Returns the current date in MM/DD/YYYY format.
  String get _formattedDate {
    final now = DateTime.now();
    return "${now.month}/${now.day}/${now.year}";
  }

  /// Starts the 60-second timer.
  void _startTimer() {
    setState(() {
      _isStarted = true;
      _isCompleted = false;
      _timeRemaining = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        // Once the timer hits 0, mark it as completed and cancel the timer.
        setState(() {
          _isCompleted = true;
        });
        _timer?.cancel();
      }
    });
  }

  Future<void> _finishLog() async {
    if (_isSaving) return; // Prevent multiple submissions

    setState(() {
      _isSaving = true;
    });

    _timer?.cancel();
    setState(() {
      _isCompleted = true;
    });

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login to save your log.")),
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    String userId = user.uid;
    final logText = _textController.text.trim();

    if (logText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter some thoughts before saving.")),
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    try {
      // Reference to user's thought_logs subcollection
      CollectionReference logsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('thought_logs');

      // Add the thought log to Firestore
      await logsRef.add({
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'logText': logText,
      });

      // Update the user stats
      await _statsService.updateAllStats();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thought log saved successfully!")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving log: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _textController.clear();
          _isStarted = false;
          _isCompleted = false;
          _timeRemaining = 60;
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thought Log'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display the current date at the top.
              Text(
                _formattedDate,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              // Show the countdown timer if it has started.
              if (_isStarted)
                Text(
                  "Time Remaining: $_timeRemaining seconds",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              const SizedBox(height: 16),
              // Text field for entering the thought log.
              Expanded(
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    hintText: "Type your thoughts here...",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  onChanged: (value) {
                    if (!_isStarted && value.trim().isNotEmpty) {
                      _startTimer();
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              // When the timer completes, display a "Log Complete" banner.
              if (_isCompleted)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.green[300],
                  child: const Text(
                    "Log Complete",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Button for the user to finalize the log.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text("Back to Home"),
                  ),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _finishLog,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.0))
                        : const Text("Complete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
