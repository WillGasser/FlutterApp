import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:health_app/auth.dart';
import 'login_screen.dart';
import 'package:health_app/home_page.dart';
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

   void _handleGuestLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

   void _handleLogin() {
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const LoginScreen(),
          ),
    );
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Create an account to get started.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              // Email field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleCreateAccount,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text("Create Account"),
                ),
              ),
              const SizedBox(height: 16),
         Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _handleLogin,
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '|',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: _handleGuestLogin,
                    child: const Text(
                      "Continue as Guest",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Continue as Guest button
             
            ],
          ),
        ),
      ),
    );
  }
}