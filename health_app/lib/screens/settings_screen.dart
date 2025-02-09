import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final bool isGuest = user == null; // Check if the user is a guest

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // If the user is logged in, display their email.
            if (!isGuest)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Logged in as: ${user!.email}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            
            // Guest View: Show account options instead of settings
            if (isGuest) ...[
              const Text(
                "You're using a guest account. Create an account to save your progress.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text("Create Account"),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text("Return to Login"),
                  ),
                ),

            ]
            // Logged-In View: Show standard settings
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
