import 'package:flutter/material.dart';
import 'package:health_app/auth.dart';
import 'login_screen.dart';
import 'package:health_app/home_page.dart';
import '../widgets/auth_widgets.dart';
import '../theme.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Added loading state variable
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles account creation using Firebase Authentication.
  Future<void> _handleCreateAccount() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    // Ensure fields are not empty
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Please fill in all fields.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Validate email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showErrorDialog("Please enter a valid email address.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Validate password strength
    if (password.length < 6) {
      _showErrorDialog("Password must be at least 6 characters long.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Create an instance of AuthService
      final authService = MyAuthService();
      final credential = await authService.registerWithEmail(email, password);

      if (!mounted) return;

      if (credential != null) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully."),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomePage(isNewLogin: true, type: "new_user")),
        );
      }
    } catch (e) {
      if (!mounted) return;

      // Show the specific error message
      _showErrorDialog(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      MaterialPageRoute(
          builder: (context) =>
              const HomePage(isNewLogin: true, type: "guest_user")),
    );
  }

  void _handleLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleAuthLayout(
      isLoading: _isLoading,
      title: "Welcome HOOM!",
      subtitle: "Create an account to get started.",
      onBackPressed: () => Navigator.pop(context),
      children: [
        AuthTextField(
          controller: _emailController,
          labelText: 'Email',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
          labelText: 'Password',
          prefixIcon: Icons.lock,
          obscureText: _obscureText,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        const SizedBox(height: 24),
        UniversalButton(
          text: "Create Account",
          onPressed: _handleCreateAccount,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _handleLogin,
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeProvider.getAuthTextColor(context),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '|',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: _handleGuestLogin,
              child: Text(
                "Continue as Guest",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeProvider.getAuthTextColor(context),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
