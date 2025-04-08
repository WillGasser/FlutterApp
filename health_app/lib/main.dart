import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added import for FieldValue
import 'package:provider/provider.dart';
import './firebase_options.dart';
import './screens/create_account_screen.dart';
import './screens/login_screen.dart';
import './home_page.dart';
import './theme.dart';
import './screens/video_screen.dart';
import './data/user_stats.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
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
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // Define routes but WITHOUT '/' (root route)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/create-account': (context) => const CreateAccountScreen(),
      },
      // Use home property for the root route
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
  final UserStatsService _statsService = UserStatsService();
  bool _isFirstLogin = false;
  String _userType = 'local_user';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.health_and_safety_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return const VideoScreen();
        }

        // Handle user login state
        _handleUserLogin(user);

        return HomePage(isNewLogin: _isFirstLogin, type: _userType);
      },
    );
  }

  // Handle user login to determine if it's a first login or return user
  Future<void> _handleUserLogin(User user) async {
    try {
      // Get the user's document reference
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Get the document
      final docSnapshot = await userDoc.get();

      // Check if the user document exists
      if (!docSnapshot.exists) {
        // First time login - create user document
        await userDoc.set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });

        // Initialize user stats
        final defaultStats = UserStats(
          weeklyActivityData: List.filled(7, 0),
          lastActiveDate: DateTime.now(),
        );

        await userDoc
            .collection('user_data')
            .doc('stats')
            .set(defaultStats.toFirestore());

        _isFirstLogin = true;

        // Determine user type based on provider
        if (user.providerData
            .any((provider) => provider.providerId == 'google.com')) {
          _userType = 'google_user';
        } else if (user.providerData
            .any((provider) => provider.providerId == 'apple.com')) {
          _userType = 'apple_user';
        } else {
          _userType = 'new_user';
        }
      } else {
        // Returning user - update last login time
        await userDoc.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });

        _isFirstLogin = false;
        _userType = 'returning_user';

        // Update login streak
        await _statsService.updateLoginStreak();
      }
    } catch (e) {
      print('Error handling user login: $e');
      // Default values in case of error
      _isFirstLogin = false;
      _userType = 'local_user';
    }
  }
}
