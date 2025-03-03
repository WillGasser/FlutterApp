import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeOverlay extends StatelessWidget {
  final VoidCallback onDismiss;
  final bool isFirstTime;
  final String? lastActivity;

  const WelcomeOverlay({
    Key? key,
    required this.onDismiss,
    required this.isFirstTime,
    this.lastActivity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onDismiss,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: size.width,
          height: size.height,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isFirstTime ? "Welcome to HOOM!" : "Welcome Back!",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isFirstTime
                          ? "HOOM helps you manage your mental wellness through thought logging, CBT techniques, and progress tracking."
                          : lastActivity != null
                              ? "Last time you $lastActivity"
                              : "Continue your wellness journey with HOOM.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Tap to enter",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper class to manage welcome message state and data
class WelcomeManager {
  static const String _firstTimeKey = 'hoom_first_time_user';

  // Check if this is the first time the user is using the app
  static Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstTimeKey) ?? true;
  }

  // Mark user as not first time
  static Future<void> markAsReturningUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, false);
  }

  // Get the user's last activity
  static Future<String?> getLastActivity() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      // Check for last thought log
      final logs = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('thought_logs')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (logs.docs.isNotEmpty) {
        return "logged your thoughts.";
      }

      return null;
    } catch (e) {
      print('Error fetching last activity: $e');
      return null;
    }
  }

  // Show the welcome overlay
  static Future<void> showWelcomeIfNeeded(BuildContext context) async {
    try {
      final isFirstTime = await isFirstTimeUser();
      String? lastActivity;

      if (!isFirstTime) {
        lastActivity = await getLastActivity();
      }

      if (!context.mounted) return;

      // Show overlay
      await showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (context) => WelcomeOverlay(
          onDismiss: () {
            Navigator.of(context).pop();
          },
          isFirstTime: isFirstTime,
          lastActivity: lastActivity,
        ),
      );

      // Mark as returning user after showing first-time message
      if (isFirstTime) {
        await markAsReturningUser();
      }
    } catch (e) {
      // Silently handle any errors to prevent app crashes
      print('Error showing welcome overlay: $e');
    }
  }
}
