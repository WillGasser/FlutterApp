import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './thought_logs_details.dart';
import 'package:intl/intl.dart';

class ThoughtLogsTab extends StatelessWidget {
  const ThoughtLogsTab({Key? key}) : super(key: key);

  // Function to format timestamp properly
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown time";
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMMM dd, yyyy • h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text("Please log in to view your thought logs."),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('thought_logs')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No thought logs yet."));
        }

        var logs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            var log = logs[index];
            var logText = log['logText'] ?? "";
            
            // Ensure timestamp is not null (Use current time as fallback)
            var timestamp = log['timestamp'] as Timestamp? ?? Timestamp.now();

            return ListTile(
              title: Text(formatTimestamp(timestamp)), // ✅ Properly formatted timestamp
              subtitle: Text(
                logText.length > 30 ? "${logText.substring(0, 30)}..." : logText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThoughtLogDetailScreen(
                      timestamp: timestamp, // ✅ Non-nullable now
                      logText: logText,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
