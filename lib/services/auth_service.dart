import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum UserType { guest, existing, newUser }

abstract class AuthService<T> {
  // Future<User> signUp({required String email, required String password});
  Future<T> authenticate({
    required String email,
    required String password,
    required UserType userType,
  });
  Future<void> logOut();
  Stream<T> get userChanges;
}

class FirebaseAuthService extends AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get user => _firebaseAuth.currentUser;

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  bool _isPasswordStrong(String password) {
    return password.length >= 6;
  }

  @override
  Future<User?> authenticate({
    required String email,
    required String password,
    required UserType userType,
  }) async {
    try {
      if (!_isEmailValid(email)) {
        throw Exception("Invalid email format.");
      }

      if (!_isPasswordStrong(password)) {
        throw Exception("Password must be at least 6 characters.");
      }

      UserCredential? credentials;

      if (userType == UserType.newUser) {
        credentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else if (userType == UserType.existing) {
        credentials = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      return credentials!.user;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
    }
    return null;
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<User?> get userChanges => _firebaseAuth.authStateChanges();
}
