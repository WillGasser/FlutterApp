import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'components/login/login_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling any Firebase methods.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase.
  await Firebase.initializeApp();

  runApp(const HealthApp());
}

class HealthApp extends StatelessWidget {
  const HealthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoodMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Raleway',
      ),
      home: const LoginScreen(),
    );
  }
}
