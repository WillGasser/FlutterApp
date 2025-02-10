import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import './firebase_options.dart';
import './screens/login_screen.dart';
import './home_page.dart'; 
import './theme.dart'; // Import ThemeProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // Provide global theme state
      child: const GoodMindApp(),
    ),
  );
}

class GoodMindApp extends StatelessWidget {
  const GoodMindApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'GoodMind',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const AuthWrapper(), // Show LoginScreen or HomePage based on auth
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

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
        return user == null ? const LoginScreen() : const HomePage();
      },
    );
  }
}
