import 'package:flutter/material.dart';
import 'screens/CBT_Training.dart';      // Provides ActivityPage widget
import './screens/my_journey_screen.dart';    // Provides MyJourneyPage widget
import './screens/settings_screen.dart'; 
import './screens/thought_log.dart' ;   

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Index for the currently selected tab
  int _currentIndex = 0;

  // List of pages to display for each tab
  final List<Widget> _pages = const [
    ThoughtLogScreen(),   
    CBTScreen(), 
    MyJourneyScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the page corresponding to the selected tab
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue, // Color when tab is selected
        unselectedItemColor: Colors.grey, // Color when tab is not selected
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'CBT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'My Journey',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
