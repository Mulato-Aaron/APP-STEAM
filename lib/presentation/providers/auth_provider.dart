import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:proyecto_5_semestre/services/auth_service.dart';
import 'auth_status.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String _errorMessage = '';
  bool _isAdmin = false;
  AuthStatus _status = AuthStatus.uninitialized;

  User? get user => _user;
  String get errorMessage => _errorMessage;
  bool get isAdmin => _isAdmin;
  AuthStatus get status => _status;

  AuthProvider() {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      _user = null;
      _isAdmin = false;
      _status = AuthStatus.unauthenticated;
    } else {
      _user = user;
      await _checkAdminStatus();
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  Future<void> _checkAdminStatus() async {
    if (_user == null) return;

    try {
      final idTokenResult = await _user!
          .getIdTokenResult(true); // Forzar la actualización del token
      final claims = idTokenResult.claims;
      _isAdmin = claims != null && claims['admin'] == true;
    } catch (e) {
      _isAdmin = false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _errorMessage = '';
      _status = AuthStatus.uninitialized;
      notifyListeners();

      await _authService.signInWithEmailAndPassword(email, password);

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthErrorMessage(e.code);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String username,
      String? photoUrl, DateTime birthDate) async {
    try {
      _errorMessage = '';
      _status = AuthStatus.uninitialized;
      notifyListeners();

      await _authService.signUpWithEmailAndPassword(
          email, password, username, photoUrl, birthDate);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthErrorMessage(e.code);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  void clearErrorMessage() {
    _errorMessage = '';
    notifyListeners();
  }

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No se encontró un usuario con ese correo electrónico.';
      case 'wrong-password':
        return 'La contraseña es incorrecta.';
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      case 'email-already-in-use':
        return 'El correo electrónico ya está en uso por otra cuenta.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      case 'user-disabled':
        return 'Esta cuenta de usuario ha sido deshabilitada.';
      case 'invalid-credential':
        return 'Credenciales inválidas. Por favor, revise su correo y contraseña.';
      default:
        return 'Ocurrió un error inesperado. Por favor, inténtelo de nuevo.';
    }
  }
}
