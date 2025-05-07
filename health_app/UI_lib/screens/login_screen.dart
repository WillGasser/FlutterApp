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
              builder: (context) => const HomePage(
                  isNewLogin: true, type: 'returning_user')),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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


//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkTheme = themeProvider.isDarkMode;
//
//     //final Color backgroundColor = isDarkTheme ? Color(0xFF121212) : Color(0xFFF8F6ED);
//     final Color inputBoxColor = isDarkTheme ? Color(0xFF3A3A35) : Colors.white;
//     final Color inputTextColor = isDarkTheme ? Colors.white : Color(0xFF4A4A40);
//     final Color hintTextColor = isDarkTheme ? Colors.grey[400]! : Color(0xFF9E9E8E);
//     final Color loginButtonColor = Color(0xFFB5BBA1);
//     final Color secondaryButtonBg = isDarkTheme ? Color(0xFF2D2D2D) : Colors.white;
//     final Color secondaryTextColor = isDarkTheme ? Colors.white : Color(0xFF4A4A40);
//     final Color dividerColor = isDarkTheme ? Colors.grey[600]! : Color(0xFFE0DFD5);
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 使用主题的背景色,
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator(color: loginButtonColor))
//           : SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final double topBottomPadding = 60.0;
//
//             return SingleChildScrollView(
//               // 添加这一行，确保内容可以滚动超出屏幕
//               physics: AlwaysScrollableScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: topBottomPadding),
//                     Text(
//                       "Welcome HOOM!",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                         color: inputTextColor,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       "Log in to continue.",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: hintTextColor,
//                       ),
//                     ),
//                     const SizedBox(height: 20), //chao change to smaller height
// // Email Field
//                     Material(
//                       color: inputBoxColor,
//                       borderRadius: BorderRadius.circular(12),
//                       clipBehavior: Clip.antiAlias,
//                       child: TextField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         textAlignVertical: TextAlignVertical.center,
//                         style: TextStyle(
//                           color: inputTextColor,
//                           fontSize: 16,
//                         ),
//                         decoration: InputDecoration(
//                           hintText: 'Email',
//                           hintStyle: TextStyle(color: hintTextColor),
//                           prefixIcon: Icon(Icons.email_outlined,
//                               color: hintTextColor, size: 20),
//                           border: InputBorder.none,
//                           enabledBorder: InputBorder.none,
//                           focusedBorder: InputBorder.none,
//                           errorBorder: InputBorder.none,
//                           disabledBorder: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 16, horizontal: 12),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 12),
//
// // Password Field
//                     Material(
//                       color: inputBoxColor,
//                       borderRadius: BorderRadius.circular(12),
//                       clipBehavior: Clip.antiAlias,
//                       child: TextField(
//                         controller: _passwordController,
//                         obscureText: _obscureText,
//                         textAlignVertical: TextAlignVertical.center,
//                         style: TextStyle(
//                           color: inputTextColor,
//                           fontSize: 16,
//                         ),
//                         decoration: InputDecoration(
//                           hintText: 'Password',
//                           hintStyle: TextStyle(color: hintTextColor),
//                           prefixIcon: Icon(Icons.lock_outline,
//                               color: hintTextColor, size: 20),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscureText
//                                   ? Icons.visibility_outlined
//                                   : Icons.visibility_off_outlined,
//                               color: hintTextColor,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _obscureText = !_obscureText;
//                               });
//                             },
//                           ),
//                           border: InputBorder.none,
//                           enabledBorder: InputBorder.none,
//                           focusedBorder: InputBorder.none,
//                           errorBorder: InputBorder.none,
//                           disabledBorder: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 16, horizontal: 12),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Login Button - 修复文字裁剪问题
//                     SizedBox(
//                       width: double.infinity,
//                       height: 48,
//                       child: ElevatedButton(
//                         onPressed: _handleLogin,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: loginButtonColor,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           elevation: 0,
//                           // 确保内部有足够的填充，防止文字裁剪
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: const Text(
//                           "Login",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             height: 1.2, // 增加行高避免裁剪
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 12),
//
//                     // Sign Up Button - 修复文字裁剪问题
//                     SizedBox(
//                       width: double.infinity,
//                       height: 48,
//                       child: OutlinedButton(
//                         onPressed: _createAccount,
//                         style: OutlinedButton.styleFrom(
//                           backgroundColor: secondaryButtonBg,
//                           side: BorderSide.none,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               color: secondaryTextColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               height: 1.2, // 增加行高避免裁剪
//                             )
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // Forgot / Guest Row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextButton(
//                           onPressed: _forgotPassword,
//                           style: TextButton.styleFrom(
//                             padding: EdgeInsets.symmetric(vertical: 8),
//                             minimumSize: Size(10, 30),
//                           ),
//                           child: Text(
//                             "Forgot Password?",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: hintTextColor,
//                               height: 1.2,
//                             ),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: _handleGuestLogin,
//                           style: TextButton.styleFrom(
//                             padding: EdgeInsets.symmetric(vertical: 8),
//                             minimumSize: Size(10, 30),
//                           ),
//                           child: Text(
//                             "Continue as Guest",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: hintTextColor,
//                               height: 1.2,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 8),
//
//                     // Divider with OR
//                     Row(
//                       children: [
//                         Expanded(
//                             child: Divider(
//                                 color: dividerColor, thickness: 1)),
//                         Padding(
//                           padding:
//                           const EdgeInsets.symmetric(horizontal: 16),
//                           child: Text("OR",
//                               style: TextStyle(
//                                   color: hintTextColor, fontSize: 14)),
//                         ),
//                         Expanded(
//                             child: Divider(
//                                 color: dividerColor, thickness: 1)),
//                       ],
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // Google Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 48,
//                       child: OutlinedButton.icon(
//                         icon: Padding(
//                           padding: const EdgeInsets.only(right: 8.0),
//                           child: Image.asset('assets/google.png',
//                               height: 20),
//                         ),
//                         label: Text(
//                             "Continue with Google",
//                             style: TextStyle(
//                               color: secondaryTextColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400,
//                               height: 1.2,
//                             )
//                         ),
//                         style: OutlinedButton.styleFrom(
//                           backgroundColor: secondaryButtonBg,
//                           side: BorderSide.none,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         onPressed: () async {
//                           setState(() => _isLoading = true);
//                           try {
//                             final user =
//                             await MyAuthService().signInWithGoogle();
//                             if (user != null) {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const HomePage(
//                                       isNewLogin: true,
//                                       type: 'google_user'),
//                                 ),
//                               );
//                             }
//                           } catch (e) {
//                             _showSnackBar("Google sign-in failed");
//                           } finally {
//                             if (mounted)
//                               setState(() => _isLoading = false);
//                           }
//                         },
//                       ),
//                     ),
//
//                     const SizedBox(height: 12),
//
//                     // Apple Button - 添加底部间距
//                     SizedBox(
//                       width: double.infinity,
//                       height: 48,
//                       child: OutlinedButton.icon(
//                         icon: Padding(
//                           padding: const EdgeInsets.only(right: 8.0),
//                           child: Icon(Icons.apple,
//                               size: 20, color: secondaryTextColor),
//                         ),
//                         label: Text(
//                             "Continue with Apple",
//                             style: TextStyle(
//                               color: secondaryTextColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400,
//                               height: 1.2,
//                             )
//                         ),
//                         style: OutlinedButton.styleFrom(
//                           backgroundColor: secondaryButtonBg,
//                           side: BorderSide.none,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         onPressed: () async {
//                           setState(() => _isLoading = true);
//                           try {
//                             final user =
//                             await MyAuthService().signInWithApple();
//                             if (user != null) {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const HomePage(
//                                       isNewLogin: true,
//                                       type: 'apple_user'),
//                                 ),
//                               );
//                             }
//                           } catch (e) {
//                             _showSnackBar("Apple sign-in failed");
//                           } finally {
//                             if (mounted)
//                               setState(() => _isLoading = false);
//                           }
//                         },
//                       ),
//                     ),
//
//                     // 增加底部间距，确保与底部有足够的空间
//                     // SizedBox(height: topBottomPadding * 1.5),
//                     // 增加底部间距 - 使用固定值
//                     SizedBox(height: 200), // 使用一个较大的固定值，而不是相对值
//                     // 将底部的SizedBox替换为Padding
//
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//above version, i left for learning how to reuse and also separate the
//logic methods and the UI code, in flutter project
 // @override
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
              _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
        // SizedBox(
        //   width: double.infinity,
        //   height: 48,
        //   child: UniversalButton(
        //     onPressed: _createAccount,
        //     child: Text("Sign Up"),
        //     isPrimary: false,
        //   ),
        // ),
        // Sign Up Button
        UniversalButton(
          text: "Sign Up",
          onPressed: _createAccount,
          isPrimary: false, // secondary button style
        ),
        const SizedBox(height: 16),

        // Forgot / Guest Row
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     TextButton(
        //       onPressed: _forgotPassword,
        //       child: Text("Forgot Password?"),
        //     ),
        //     TextButton(
        //       onPressed: _handleGuestLogin,
        //       child: Text("Continue as Guest"),
        //     ),
        //   ],
        // ),
        //above old version, next one is using wrap for fully responsive design
        //chao 4/21 4:10am， but will cause login with google be hided
        //so using row with manual compression to make sure every content can
        //be on the screen
        // Wrap(
        //   alignment: WrapAlignment.center,
        //   spacing: 24, // 按钮之间的水平间距
        //   runSpacing: 8, // 换行后的垂直间距
        //   children: [
        //     TextButton(
        //       onPressed: _forgotPassword,
        //       child: Text("Forgot Password?"),
        //     ),
        //     TextButton(
        //       onPressed: _handleGuestLogin,
        //       child: Text("Continue as Guest"),
        //     ),
        //   ],
        // ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextButton(
                onPressed: _forgotPassword,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(fontSize: 14), // 可选小一点
                ),
              ),
            ),
            Flexible(
              child: TextButton(
                onPressed: _handleGuestLogin,
                child: Text(
                  "Continue as Guest",
                  style: TextStyle(fontSize: 14), // 可选小一点
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