import 'package:flutter/material.dart';
import './thought_logs_tab.dart'; // Thought Logs Tab
import './CBT_Trainings_tab.dart'; // Placeholder for CBT Trainings
import './analytics_tab.dart'; // Placeholder for Analytics

class MyJourneyScreen extends StatelessWidget {
  const MyJourneyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Journey"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.edit_note), text: "Thought Logs"),
              Tab(icon: Icon(Icons.lightbulb), text: "CBT Trainings"),
              Tab(icon: Icon(Icons.bar_chart), text: "Analytics"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ThoughtLogsTab(), // Thought Logs Tab
            CBTTrainingsTab(), // Placeholder for CBT
            AnalyticsTab(), // Placeholder for Analytics
          ],
        ),
      ),
    );
  }
}
