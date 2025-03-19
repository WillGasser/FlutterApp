import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import './theme.dart';
import 'sidebar.dart';
import 'screens/thought_log.dart';
import 'screens/CBT_Training.dart';
import 'screens/my_journey/my_journey_screen.dart';
import './welcome_overlay.dart';

class HomePage extends StatefulWidget {
  final bool isNewLogin;
  
  const HomePage({Key? key, required this.isNewLogin}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  bool _showWelcome = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 100));

      if (widget.isNewLogin) {
        _showWelcome = true;
      }

      setState(() {
        _isLoading = false;
      });

      if (mounted && _showWelcome) {
        await WelcomeManager.showWelcomeIfNeeded(context);
      }
    } catch (e) {
      print('Error initializing app: $e');
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

    final primaryColor = isDark ? Colors.tealAccent : Colors.blue;
    final secondaryColor = isDark ? const Color(0xFF2A2D3E) : Colors.white;
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
        title: const Text('HOOM'),
        centerTitle: true,
      ),
      drawer: const SideBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedCircleButton(
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
                  0, // First button animation delay
                ),
                const SizedBox(height: 30),
                _buildAnimatedCircleButton(
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
                  300, // Second button animation delay
                ),
                const SizedBox(height: 30),
                _buildAnimatedCircleButton(
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
                  600, // Third button animation delay
                ),
              ],
            ),
          ],
        )
            .animate()
            .fade(duration: 600.ms) // Fade in effect
            .slideY(begin: 0.1, end: 0, duration: 800.ms), // Slide up effect
      ),
    );
  }

  Widget _buildAnimatedCircleButton(
    BuildContext context,
    IconData icon,
    String label,
    Color primaryColor,
    Color secondaryColor,
    Color textColor,
    VoidCallback onPressed,
    int delay,
  ) {
    return Column(
      children: [
        Material(
          color: primaryColor,
          shape: const CircleBorder(),
          elevation: 4,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Center(
                child: Icon(icon, size: 72, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(fontSize: 32, color: textColor, fontWeight: FontWeight.bold),
        ),
      ],
    )
        .animate()
        .fade(duration: 500.ms, delay: delay.ms) // Fade in with delay
        .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: delay.ms) // Slide up
        .scaleXY(begin: 0.7, end: 1.0, duration: 500.ms, curve: Curves.bounceOut); // Bounce effect
  }
}
