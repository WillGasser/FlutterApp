import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _resetPassword() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage("Please enter your email.");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showMessage("Password reset email sent. Check your inbox.");
    } catch (e) {
      _showMessage("Error: ${e.toString()}");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Reset Your Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter your email and we'll send a link to reset your password.",
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
              const SizedBox(height: 24),

              // Reset Password Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text("Reset Password"),
                ),
              ),
              const SizedBox(height: 16),

              // Back to Login Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Back to Login",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
