import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme.dart';
import 'sidebar.dart';
import 'screens/thought_log.dart';
import 'screens/CBT_Training.dart';
import 'screens/my_journey/my_journey_screen.dart';
import './welcome_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize and then show welcome
    _initializeApp();
  }

  // Safe initialization sequence
  Future<void> _initializeApp() async {
    try {
      // Ensure the widget is still mounted
      if (!mounted) return;

      // Allow the app to render first
      await Future.delayed(const Duration(milliseconds: 100));

      setState(() {
        _isLoading = false;
      });

      // Show welcome message after app has rendered
      if (mounted) {
        await WelcomeManager.showWelcomeIfNeeded(context);
      }
    } catch (e) {
      print('Error initializing app: $e');
      // Ensure we're not stuck in loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // Define colors based on theme
    final primaryColor = isDark ? Colors.tealAccent : Colors.blue;
    final secondaryColor = isDark ? const Color(0xFF2A2D3E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('HOOM'),
        centerTitle: true,
      ),
      drawer: const SideBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to HOOM',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Your mental wellness companion',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            // Circular buttons in a row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Thought Log button
                _buildCircleButton(
                  context,
                  Icons.edit_note,
                  'Log',
                  primaryColor,
                  secondaryColor,
                  textColor,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ThoughtLogScreen()),
                  ),
                ),

                const SizedBox(width: 30),

                // CBT Training button
                _buildCircleButton(
                  context,
                  Icons.lightbulb,
                  'CBT',
                  primaryColor,
                  secondaryColor,
                  textColor,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CBTScreen()),
                  ),
                ),

                const SizedBox(width: 30),

                // Journey button
                _buildCircleButton(
                  context,
                  Icons.timeline,
                  'Journey',
                  primaryColor,
                  secondaryColor,
                  textColor,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyJourneyScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(
    BuildContext context,
    IconData icon,
    String label,
    Color primaryColor,
    Color secondaryColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        // Circle button
        Material(
          color: primaryColor,
          shape: const CircleBorder(),
          elevation: 4,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Label text
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
