import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import './theme.dart';
import 'sidebar.dart';
import 'screens/thought_log.dart';
import 'screens/CBT_Training.dart';
import 'screens/my_journey/my_journey_screen.dart';
import './welcome_overlay.dart';
import 'button_effect.dart';
class HomePage extends StatefulWidget {
  final bool isNewLogin;
  final String type; 
  const HomePage({Key? key, required this.isNewLogin, required this.type}) : super(key: key);

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
        await WelcomeManager.showWelcomeIfNeeded(context, widget.type);
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
        // Group of buttons appear with fade and slide-up animation.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomCircleButton(
              icon: Icons.edit_note,
              label: 'Log',
              primaryColor: primaryColor,
              textColor: textColor,
              onPressed: () {
                      // Get the tapped button's center in global coordinates.
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      final Offset center = box.localToGlobal(box.size.center(Offset.zero));
                      
                      Navigator.of(context).push(
                        CircularRevealRoute(
                          page: const ThoughtLogScreen(),
                          center: center,
                          fillColor: primaryColor, // This will be your blue color
                        ),
                      );
                    },
            ),
            const SizedBox(height: 30),
            ZoomCircleButton(
              icon: Icons.lightbulb,
              label: 'CBT',
              primaryColor: primaryColor,
              textColor: textColor,
             onPressed: () {
                        // Get the tapped button's center in global coordinates.
                        final RenderBox box = context.findRenderObject() as RenderBox;
                        final Offset center = box.localToGlobal(box.size.center(Offset.zero));
                        
                        Navigator.of(context).push(
                          CircularRevealRoute(
                            page: const CBTScreen(),
                            center: center,
                            fillColor: primaryColor, // This will be your blue color
                          ),
                        );
                      },),
            const SizedBox(height: 30),
            ZoomCircleButton(
              icon: Icons.timeline,
              label: 'Journey',
              primaryColor: primaryColor,
              textColor: textColor,
             onPressed: () {
  // Get the tapped button's center in global coordinates.
                        final RenderBox box = context.findRenderObject() as RenderBox;
                        final Offset center = box.localToGlobal(box.size.center(Offset.zero));
                        
                        Navigator.of(context).push(
                          CircularRevealRoute(
                            page: const MyJourneyScreen(),
                            center: center,
                            fillColor: primaryColor, // This will be your blue color
                          ),
                        );
                      },
            ),
          ],
        )
        .animate()
        .fade(duration: 600.ms)
        .slideY(begin: 0.1, end: 0, duration: 800.ms),
      ),
    );
  }
}

/// ZoomCircleButton is a custom widget that zooms (scales up) when tapped.
/// Once the zoom animation completes, it navigates to the provided page.
class ZoomCircleButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color primaryColor;
  final Color textColor;
  final VoidCallback onPressed;
  
  const ZoomCircleButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.primaryColor,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);
  
  @override
  _ZoomCircleButtonState createState() => _ZoomCircleButtonState();
}

class _ZoomCircleButtonState extends State<ZoomCircleButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  
  @override
  void initState(){
    super.initState();
    _controller = AnimationController(
      duration: 30.ms,
      vsync: this,
    );
    // When the zoom animation completes, navigate and then reverse the animation.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onPressed();
        _controller.reverse();
      }
    });
  }
  
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward();
      },
      child: Column(
        children: [
          Material(
            color: widget.primaryColor,
            shape: const CircleBorder(),
            elevation: 4,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Center(
                child: Icon(widget.icon, size: 72, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 32,
              color: widget.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ).animate(controller: _controller)
       .scaleXY(
         begin: 1.0, 
         end: 1.2, 
         duration: 300.ms, 
         curve: Curves.easeInOut,
       ),
    );
  }
}
