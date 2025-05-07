import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'thought_logs_details.dart';
import '../../theme.dart';

class ThoughtLogsTab extends StatefulWidget {
  const ThoughtLogsTab({Key? key}) : super(key: key);

  @override
  State<ThoughtLogsTab> createState() => _ThoughtLogsTabState();
}

class _ThoughtLogsTabState extends State<ThoughtLogsTab> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _thoughtLogs = [];

  @override
  void initState() {
    super.initState();
    _fetchThoughtLogs();
  }

  Future<void> _fetchThoughtLogs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle guest user case
        setState(() {
          _thoughtLogs = [];
          _isLoading = false;
        });
        return;
      }

      // Get user's thought logs
      final logsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('thought_logs')
          .orderBy('timestamp', descending: true)
          .get();

      final logs = logsSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'timestamp': data['timestamp'] ?? Timestamp.now(),
          'logText': data['logText'] ?? 'No content',
        };
      }).toList();

      if (mounted) {
        setState(() {
          _thoughtLogs = logs;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching thought logs: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return DateFormat('MMM dd, yyyy • h:mm a').format(dateTime);
  }

  String _getPreviewText(String text) {
    if (text.length <= 100) {
      return text;
    }
    return '${text.substring(0, 100)}...';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    if (_thoughtLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_note,
              size: 64,
              color: isDark ? Colors.grey[700] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No thought logs yet',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Your thought logs will appear here once you create them',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/thought-log');
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Thought Log'),
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
      onRefresh: _fetchThoughtLogs,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _thoughtLogs.length,
        itemBuilder: (context, index) {
          final log = _thoughtLogs[index];
          final timestamp = log['timestamp'] as Timestamp;
          final logText = log['logText'] as String;

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
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThoughtLogDetailScreen(
                      timestamp: timestamp,
                      logText: logText,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.event_note,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTimestamp(timestamp),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getPreviewText(logText),
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Tap to view details →',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
