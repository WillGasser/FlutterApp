import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
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

  // @override
  // Widget build(BuildContext context) {
  //   // 使用Theme.of(context)获取当前主题
  //   final theme = Theme.of(context);
  //
  //   // 使用ThemeProvider中的辅助方法获取认证页面颜色
  //   final primaryColor = ThemeProvider.getAuthPrimaryColor(context);
  //   final textColor = ThemeProvider.getAuthTextColor(context);
  //   final hintColor = ThemeProvider.getAuthHintColor(context);
  //   final inputBoxColor = ThemeProvider.getAuthInputBoxColor(context);
  //
  //   return Scaffold(
  //     backgroundColor: theme.scaffoldBackgroundColor,
  //     appBar: AppBar(),
  //     body: _isLoading
  //         ? Center(child: CircularProgressIndicator(color: primaryColor))
  //         : Align(
  //       alignment: Alignment(0, -0.5),
  //       child: Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Text(
  //               "Reset Your Password",
  //               style: TextStyle(
  //                 fontSize: 24,
  //                 fontWeight: FontWeight.w600,
  //                 color: textColor,
  //               ),
  //             ),
  //             const SizedBox(height: 6),
  //             Text(
  //               "Enter your email and we'll send a link to reset your password.",
  //               style: TextStyle(fontSize: 14, color: hintColor),
  //               textAlign: TextAlign.center,
  //             ),
  //             const SizedBox(height: 30),
  //
  //             // Email field
  //             Material(
  //               color: inputBoxColor,
  //               borderRadius: BorderRadius.circular(ThemeProvider.authBorderRadius),
  //               clipBehavior: Clip.antiAlias,
  //               child: TextField(
  //                 controller: _emailController,
  //                 keyboardType: TextInputType.emailAddress,
  //                 style: TextStyle(color: textColor, fontSize: 16),
  //                 decoration: InputDecoration(
  //                   hintText: 'Email',
  //                   hintStyle: TextStyle(color: hintColor),
  //                   prefixIcon: Icon(Icons.email_outlined, color: hintColor, size: 20),
  //                   border: InputBorder.none,
  //                   enabledBorder: InputBorder.none,
  //                   focusedBorder: InputBorder.none,
  //                   errorBorder: InputBorder.none,
  //                   disabledBorder: InputBorder.none,
  //                   contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //
  //             // Reset Password Button
  //             SizedBox(
  //               width: double.infinity,
  //               height: 48,
  //               child: ElevatedButton(
  //                 onPressed: _resetPassword,
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: primaryColor,
  //                   foregroundColor: Colors.white,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(ThemeProvider.authBorderRadius),
  //                   ),
  //                   elevation: 0,
  //                   padding: EdgeInsets.symmetric(vertical: 12),
  //                 ),
  //                 child: Text(
  //                   "Reset Password",
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500,
  //                     height: 1.2,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Back to Login Button
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               style: TextButton.styleFrom(
  //                 padding: EdgeInsets.symmetric(vertical: 8),
  //                 minimumSize: Size(10, 30),
  //               ),
  //               child: Text(
  //                 "Back to Login",
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: hintColor,
  //                   height: 1.2,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

//above is the old version  without using theme.dart and authen_widgets
//compare with below new version to learn how powerful of reusablity of
//code can make code clean
  @override
  Widget build(BuildContext context) {
    return SimpleAuthLayout(
      isLoading: _isLoading,
      title: "Reset Your Password",
      subtitle: "Enter your email and we'll send a link to reset your password.",
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