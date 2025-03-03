import 'package:firebase_auth/firebase_auth.dart';

class MyAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get userStream => _auth.authStateChanges();

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  Future<UserCredential?> registerWithEmail(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error registering: $e');
    }
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Exception(
            'This email is already in use. Please try another email or login.');
      case 'invalid-email':
        return Exception(
            'Invalid email format. Please check your email address.');
      case 'weak-password':
        return Exception(
            'Password is too weak. Please use a stronger password.');
      case 'user-not-found':
        return Exception(
            'No account found with this email. Please register first.');
      case 'wrong-password':
        return Exception('Incorrect password. Please try again.');
      case 'user-disabled':
        return Exception(
            'This account has been disabled. Please contact support.');
      case 'too-many-requests':
        return Exception('Too many attempts. Please try again later.');
      case 'operation-not-allowed':
        return Exception(
            'This operation is not allowed. Please contact support.');
      default:
        return Exception('Authentication error: ${e.message}');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
