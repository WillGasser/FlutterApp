import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  /// Handles user logout and redirects to LoginScreen.
  void _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase

      // Redirect to LoginScreen and clear navigation stack
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error logging out: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user == null;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        // Add a back button to return to previous screen
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display user email or guest status
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                isGuest ? "Guest Account" : (user?.email ?? "Unknown Email"),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // Settings List
            Expanded(
              child: ListView(
                children: [
                  // Theme Toggle Switch for all users
                  SwitchListTile(
                    title: const Text("Dark Mode"),
                    secondary: themeProvider.isDarkMode
                        ? const Icon(Icons.nightlight_round) // 🌙 Dark Mode
                        : const Icon(Icons.wb_sunny), // 🌞 Light Mode
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  ),

                  const Divider(),

                  // Show account settings only for registered users
                  if (!isGuest) ...[
                    const ListTile(
                      title: Text('Account'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text('Notifications'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text('Privacy'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    const Divider(),
                  ],

                  // Logout button for all users (registered and guests)
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: Text(isGuest ? 'Back to Login' : 'Log Out'),
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
