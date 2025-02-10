import 'package:flutter/material.dart';
import 'package:health_app/auth.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles account creation using Firebase Authentication.
  Future<void> _handleCreateAccount() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    // Ensure fields are not empty.
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Please fill in all fields.");
      return;
    }

 try {
  // Create an instance of AuthService
   final authService = MyAuthService(); 
   final user = await authService.registerWithEmail(email, password);

  if (!mounted) return;

  if (user != null) {
    // Registration successful
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account created successfully."),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context); // Navigate back or to home screen
  } else {
    // Registration failed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account creation failed."),
        backgroundColor: Colors.red,
      ),
    );
  }
} catch (e) {
  if (!mounted) return;

  // Catch any errors thrown during account creation
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(e.toString()),
      backgroundColor: Colors.red,
    ),
  );
}

  }

  /// Displays an AlertDialog with the provided error message.
  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            // Create Account button
            ElevatedButton(
              onPressed: _handleCreateAccount,
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
