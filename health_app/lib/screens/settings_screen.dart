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

      // Redirect to LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user == null;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isGuest)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  user.email ?? "Unknown Email",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            if (isGuest) ...[
              const Text(
                "You're using a guest account.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [

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

                    ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('Return'),
                      onTap: () => _handleLogout(context),
                    ),
                  ],
                ),
              ),
            ]
            else
              Expanded(
                child: ListView(
                  children: [
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

                    // 🌞🌙 Theme Toggle Switch
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
                    ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('Log Out'),
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
