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
      _status = AuthStatus.authenticated;

      // Notifica a los listeners inmediatamente para navegar fuera de las pantallas de autenticación.
      // La UI asumirá inicialmente que el usuario no es un administrador.
      notifyListeners();

      // Ahora, comprueba el estado de administrador en segundo plano y notifica de nuevo si cambia.
      await _checkAdminStatus();
    }
    // Una notificación final para asegurar que la UI sea consistente después de la comprobación de administrador.
    notifyListeners();
  }

  Future<void> _checkAdminStatus() async {
    if (_user == null) {
      _isAdmin = false;
      return;
    }

    try {
      // Fuerza una actualización para obtener los últimos custom claims.
      final idTokenResult = await _user!.getIdTokenResult(true);
      final claims = idTokenResult.claims;
      final newIsAdmin = claims != null && claims['admin'] == true;
      if (newIsAdmin != _isAdmin) {
        _isAdmin = newIsAdmin;
      }
    } catch (e) {
      // Si hay un error, asume que no es un administrador.
      _isAdmin = false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _errorMessage = '';
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
      await _authService.signUpWithEmailAndPassword(
          email, password, username, photoUrl, birthDate);

      await _authService.signInWithEmailAndPassword(email, password);

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
