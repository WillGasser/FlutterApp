import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _resetPassword() async {
    setState(() => _isLoading = true);

    String email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage("Please enter your email.");
      setState(() => _isLoading = false);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showMessage("Password reset email sent. Check your inbox.");
    } catch (e) {
      _showMessage("Error: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleAuthLayout(
      isLoading: _isLoading,
      title: "Reset Your Password",
      subtitle:
          "Enter your email and we'll send a link to reset your password.",
      onBackPressed: () => Navigator.pop(context),
      children: [
        // Email field
        AuthTextField(
          controller: _emailController,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),

        // Reset Password button
        UniversalButton(
          text: "Reset Password",
          onPressed: _resetPassword,
        ),
        const SizedBox(height: 16),

        // Back to Login button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Back to Login"),
        ),
      ],
    );
  }
}
