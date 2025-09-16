import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Wichtig: User ist bereits automatisch angemeldet nach Registrierung
      print('Registration successful for user: ${user?.email}');
      return user;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuth Registration error: ${e.code} - ${e.message}');
      throw e; // Weitergeben für spezifische Fehlerbehandlung
    } catch (e) {
      print('General Registration error: $e');
      throw e;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      print('Sign in successful for user: ${user?.email}');
      return user;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuth Sign in error: ${e.code} - ${e.message}');
      throw e; // Weitergeben für spezifische Fehlerbehandlung
    } catch (e) {
      print('General Sign in error: $e');
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Sign out error: $e');
      throw e;
    }
  }
}
