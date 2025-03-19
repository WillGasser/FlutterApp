import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import './firebase_options.dart';
import './screens/create_account_screen.dart';
import './screens/login_screen.dart';
import './home_page.dart';
import './theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const HoomApp(),
    ),
  );
}

class HoomApp extends StatelessWidget {
  const HoomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'HOOM',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/create-account': (context) => const CreateAccountScreen(),
      },
      // Keep only the home property
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isNewLogin = false;

  @override
  void initState() {
    super.initState();
    _checkAuthEvent();
  }

  Future<void> _checkAuthEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the user is being manually authenticated (not auto login)
    bool isNewLogin = prefs.getBool('isNewLogin') ?? false;

    if (isNewLogin) {
      setState(() {
        _isNewLogin = true;
      });

      // Reset flag after first use so next launches don’t show welcome
      await prefs.setBool('isNewLogin', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          // User is signing in → Mark this as a new login event
          SharedPreferences.getInstance().then((prefs) {
            prefs.setBool('isNewLogin', true);
          });
          return const CreateAccountScreen();
        }

        return HomePage(isNewLogin: _isNewLogin);
      },
    );
  }
}