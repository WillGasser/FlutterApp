import 'package:flutter/material.dart';
import 'package:health_app/auth.dart';
import 'login_screen.dart';
import 'package:health_app/home_page.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import 'package:health_app/widgets/auth_widgets.dart'; // 1/3 of the ways to import in flutter: 1."package"
//2. relative import '../theme.dart' 3.absolute import never recommend in flutter since throw exception
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Added loading state variable

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
          MaterialPageRoute(builder: (context) => const HomePage(isNewLogin:true, type: "new_user")),
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
      MaterialPageRoute(builder: (context) => const HomePage(isNewLogin: true, type: "guest_user")),
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

  // @override
  // Widget build(BuildContext context) {
  //   // 使用主题
  //   final theme = Theme.of(context);
  //
  //   // 使用ThemeProvider中的辅助方法获取认证页面颜色
  //   final primaryColor = ThemeProvider.getAuthPrimaryColor(context);
  //   final textColor = ThemeProvider.getAuthTextColor(context);
  //   final hintColor = ThemeProvider.getAuthHintColor(context);
  //
  //   return Scaffold(
  //     backgroundColor: theme.scaffoldBackgroundColor, // 使用主题的背景色
  //     appBar: AppBar(), // theme.dart set everything
  //
  //     body: _isLoading
  //         ? Center(child: CircularProgressIndicator(color: primaryColor))
  //         : Align(
  //       //use align+fractionaloffset to move a little bit up
  //       alignment: Alignment(0, -0.5), // y轴小于0越靠上，范围 [-1, 1]
  //       child: Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Text(
  //               "Welcome HOOM!",
  //               style: TextStyle(
  //                 fontSize: 26,
  //                 fontWeight: FontWeight.bold,
  //                 color: textColor,
  //               ),
  //             ),
  //             const SizedBox(height: 8),
  //             Text(
  //               "Create an account to get started.",
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: hintColor,
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //             const SizedBox(height: 30),
  //
  //             // Email field
  //             TextField(
  //               controller: _emailController,
  //               decoration: InputDecoration(
  //                 labelText: 'Email',
  //                 prefixIcon: Icon(Icons.email),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(ThemeProvider.authBorderRadius),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Password field
  //             TextField(
  //               controller: _passwordController,
  //               obscureText: true,
  //               decoration: InputDecoration(
  //                 labelText: 'Password',
  //                 prefixIcon: Icon(Icons.lock),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(ThemeProvider.authBorderRadius),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 24),
  //
  //             // Buttons
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: _handleCreateAccount,
  //                 style: theme.elevatedButtonTheme.style?.copyWith(
  //                   shape: MaterialStateProperty.all(
  //                     RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(ThemeProvider.authBorderRadius),
  //                     ),
  //                   ),
  //                 ),
  //                 child: Text("Create Account"),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 TextButton(
  //                   onPressed: _handleLogin,
  //                   child: Text(
  //                     "Login",
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       color: textColor,
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 8.0),
  //                   child: Text(
  //                     '|',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       color: hintColor,
  //                     ),
  //                   ),
  //                 ),
  //                 TextButton(
  //                   onPressed: _handleGuestLogin,
  //                   child: Text(
  //                     "Continue as Guest",
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       color: textColor,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 10),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //below is the version to use auth_widgets to reuse the code of same layout of the sign-up forgot
  //password
  //above is the old version, duplicated code as forgot password page
  //chao 4/21 2:22am
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
          obscureText: true,
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