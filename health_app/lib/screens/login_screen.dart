import 'package:flutter/material.dart';
import 'package:health_app/auth.dart';
import '../home_page.dart';
import 'create_account_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for email and password fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles login using Firebase authentication.
  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    // Check that both fields are filled.
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Attempt to sign in with Firebase.
      final authService = MyAuthService();
      final user = await authService.signInWithEmail(email, password);

      if (user != null) {
        // If sign in is successful, navigate to the HomePage.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage(isNewLogin: true)),
        );
      } else {
        // If user is null, sign in failed.
        _showSnackBar('Login failed. Please check your credentials.');
      }
    } catch (e) {
      // Catch and show any errors that occur during sign in.
      _showSnackBar(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handles guest login (skips authentication)
  void _handleGuestLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage(isNewLogin: true)),
    );
  }

  /// Shows a SnackBar with the given message.
  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Shows an AlertDialog with the provided error message.
  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void _CreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateAccountScreen(),
      ),
    );
  }

  void _ForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome Back!",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Log in to continue.",
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

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Create Account & Forgot Password buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: _CreateAccount,
                          child: const Text(
                            "Create Account",
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
                          onPressed: _ForgotPassword,
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Guest Login button
                    TextButton(
                      onPressed: _handleGuestLogin,
                      child: const Text(
                        "Continue as Guest",
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
