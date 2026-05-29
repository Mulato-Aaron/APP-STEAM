import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  User? get user => _user;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<User?> signInAnonymously() async {
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      _user = userCredential.user;
      notifyListeners();
      return _user;
    } catch (e) {
      debugPrint('Error during anonymous sign in: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
      return _user;
    } catch (e) {
      debugPrint('Error during email sign in: $e');
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username, String? photoUrl, DateTime birthDate) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      if (_user != null) {
        await _firestore.collection('users').doc(_user!.uid).set({
          'username': username,
          'email': email,
          'photoUrl': photoUrl,
          'birthDate': Timestamp.fromDate(birthDate),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      notifyListeners();
      return _user;
    } catch (e) {
      debugPrint('Error during email sign up: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
