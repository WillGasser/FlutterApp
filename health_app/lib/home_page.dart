import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme.dart'; // Import ThemeProvider
import 'screens/CBT_Training.dart';
import 'screens/my_journey/my_journey_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/thought_log.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // Display the page corresponding to the selected tab
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures consistent coloring
        selectedItemColor: themeProvider.isDarkMode ? Colors.tealAccent : Colors.blue, // Adapts to theme
        unselectedItemColor: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey, // Adapts to theme
        backgroundColor: themeProvider.isDarkMode ? const Color.fromARGB(255, 35, 34, 34) : Colors.white, // Changes background color
        currentIndex: _currentIndex, // Ensures proper highlighting
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
