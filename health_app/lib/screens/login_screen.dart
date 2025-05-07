import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../home_page.dart';
import '../auth.dart';
import 'create_account_screen.dart';
import 'forgot_password_screen.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final authService = MyAuthService();
      final user = await authService.signInWithEmail(email, password);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomePage(isNewLogin: true, type: 'returning_user')),
        );
      } else {
        _showSnackBar('Login failed. Please check your credentials.');
      }
    } catch (e) {
      _showSnackBar(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleGuestLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const HomePage(isNewLogin: true, type: 'guest_user')),
    );
  }

  void _createAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
    );
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

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

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user = await MyAuthService().signInWithGoogle();
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(
              isNewLogin: true,
              type: 'google_user',
            ),
          ),
        );
      }
    } catch (e) {
      _showSnackBar("Google sign-in failed");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user = await MyAuthService().signInWithApple();
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(
              isNewLogin: true,
              type: 'apple_user',
            ),
          ),
        );
      }
    } catch (e) {
      _showSnackBar("Apple sign-in failed");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedAuthLayout(
      isLoading: _isLoading,
      title: "Welcome HOOM!",
      subtitle: "Log in to continue.",
      mainChildren: [
        // Email Field
        AuthTextField(
          controller: _emailController,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),

        // Password Field
        AuthTextField(
          controller: _passwordController,
          hintText: 'Password',
          prefixIcon: Icons.lock_outline,
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
        const SizedBox(height: 20),

        // Login Button
        UniversalButton(
          text: "Login",
          onPressed: _handleLogin,
        ),
        const SizedBox(height: 12),

        // Sign Up Button
        UniversalButton(
          text: "Sign Up",
          onPressed: _createAccount,
          isPrimary: false, // secondary button style
        ),
        const SizedBox(height: 16),

        // Forgot / Guest Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextButton(
                onPressed: _forgotPassword,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(fontSize: 14), // smaller font size
                ),
              ),
            ),
            Flexible(
              child: TextButton(
                onPressed: _handleGuestLogin,
                child: Text(
                  "Continue as Guest",
                  style: TextStyle(fontSize: 14), // smaller font size
                ),
              ),
            ),
          ],
        ),
      ],
      divider: const OrDivider(),
      socialLoginChildren: [
        // Google Button
        SocialLoginButton(
          text: "Continue with Google",
          icon: Image.asset('assets/google.png', height: 20),
          onPressed: _handleGoogleSignIn,
        ),
        const SizedBox(height: 12),

        // Apple Button
        SocialLoginButton(
          text: "Continue with Apple",
          icon: Icon(Icons.apple, size: 20),
          onPressed: _handleAppleSignIn,
        ),
      ],
    );
  }
}
