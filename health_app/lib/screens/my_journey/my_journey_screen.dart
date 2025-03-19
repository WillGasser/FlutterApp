import 'package:flutter/material.dart';
import 'thought_logs_tab.dart'; // Make sure this import is correct
import 'CBT_Trainings_tab.dart';
import 'analytics_tab.dart';

class MyJourneyScreen extends StatelessWidget {
  const MyJourneyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Journey'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.edit_note), text: "Thought Logs"),
              Tab(icon: Icon(Icons.lightbulb), text: "CBT Trainings"),
              Tab(icon: Icon(Icons.bar_chart), text: "Analytics"),
            ],
          ),
          actions: [
            // Home button in the app bar
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Back to Home',
            ),
          ],
        ),
        // Removed drawer temporarily
        body: TabBarView(
          children: [
            ThoughtLogsTabContent(), // Fixed with a new class below
            const CBTTrainingsTab(),
            const AnalyticsTab(),
          ],
        ),
      ),
    );
  }
}

// Create a temporary implementation of the ThoughtLogsTab
class ThoughtLogsTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Your thought logs will appear here'),
    );
  }
}