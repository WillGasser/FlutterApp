import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/user_stats.dart';

/// This screen implements a free-form thought log where the user can write
/// and submit without a timer.
class ThoughtLogScreen extends StatefulWidget {
  const ThoughtLogScreen({Key? key}) : super(key: key);

  @override
  State<ThoughtLogScreen> createState() => _ThoughtLogScreenState();
}

class _ThoughtLogScreenState extends State<ThoughtLogScreen> {
  final TextEditingController _textController = TextEditingController();
  final UserStatsService _statsService = UserStatsService();
  bool _isSaving = false;

  String get _formattedDate {
    final now = DateTime.now();
    return "${now.month}/${now.day}/${now.year}";
  }

  Future<void> _finishLog() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
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
        const SnackBar(content: Text("Please enter some thoughts before saving.")),
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    try {
      CollectionReference logsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('thought_logs');

      await logsRef.add({
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'logText': logText,
      });

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
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
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
              Text(
                _formattedDate,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
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
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text("Back to Home"),
                  ),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _finishLog,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    )
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
