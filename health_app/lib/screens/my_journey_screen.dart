import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyJourneyScreen extends StatelessWidget {
  const MyJourneyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text("Please log in to view your thought logs."),
      );
    }

    return Scaffold(
  appBar: AppBar(title: const Text("Thought Log History")),
  body: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('thought_logs') // Fetch only this user's logs
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
          var timestamp = (log['timestamp'] as Timestamp?)?.toDate();

          return ListTile(
            title: Text(logText),
            subtitle: Text(timestamp?.toString() ?? "Unknown time"),
          );
        },
      );
    },
  ),
);

  }
}
