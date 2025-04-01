import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme.dart';
import 'sidebar.dart';
import 'screens/thought_log.dart';
import 'screens/CBT_Training.dart';
import 'welcome_overlay.dart';

class HomePage extends StatefulWidget {
  final bool isNewLogin;
  final String type; 
  const HomePage({Key? key, required this.isNewLogin, required this.type}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Home is the default selected index.
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

 Future<void> _initializeApp() async {
  try {
    // Small delay in case you want to simulate loading.
    await Future.delayed(const Duration(milliseconds: 100));

    if (widget.isNewLogin) {
      print('Showing welcome overlay for new login.');
      await WelcomeManager.showWelcomeIfNeeded(context, widget.type);
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  } catch (e) {
    print('Error initializing app: $e');
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  void _onItemTapped(int index) {
    // Do nothing if tapping the already-selected item.
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the appropriate screen based on the selected index.
    if (index == 0) {
      // Navigate to CBT training screen.
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CBTScreen()),
      );
    } else if (index == 2) {
      // Navigate to Thought log screen.
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ThoughtLogScreen()),
      );
    }
    // If index == 1, it's Home, so we remain on the current page.
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = isDark ? Colors.tealAccent : Colors.blue;
    final textColor = isDark ? Colors.white : Colors.black87;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // Use a Builder to ensure the correct context for opening the drawer.
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Home'),
        centerTitle: true,
      ),
      drawer: const SideBar(),
      body: Container(), // Empty main body to be implemented later.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primaryColor,
        unselectedItemColor: textColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'CBT training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'Thought log',
          ),
        ],
      ),
    );
  }
}
