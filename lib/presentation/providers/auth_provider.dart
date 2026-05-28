import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'auth_status.dart'; // Importar el nuevo enum

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Timer? _authTimer;
  String _errorMessage = '';
  bool _isAdmin = false;
  AuthStatus _status = AuthStatus.uninitialized; // Nueva propiedad de estado

  User? get currentUser => _user;
  String get errorMessage => _errorMessage;
  bool get isAdmin => _isAdmin;
  AuthStatus get status => _status; // Getter para el estado

  AuthProvider() {
    _auth.authStateChanges().listen(onAuthStateChanged);
  }

  Future<void> onAuthStateChanged(User? user) async {
    if (user == null) {
      _user = null;
      _isAdmin = false;
      _status = AuthStatus.unauthenticated;
      if (_authTimer != null) {
        _authTimer!.cancel();
        _authTimer = null;
      }
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
      final idTokenResult = await _user!.getIdTokenResult(true);
      final claims = idTokenResult.claims;
      _isAdmin = claims != null && claims['admin'] == true;
    } catch (e) {
      _isAdmin = false;
      _errorMessage = 'Error al verificar los permisos: ${e.toString()}';
    }
    // No notificamos aquí para evitar un rebuild extra, onAuthStateChanged lo hará.
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _errorMessage = '';
      notifyListeners(); // Notificar que estamos intentando iniciar sesión
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthErrorMessage(e.code);
      _status =
          AuthStatus.unauthenticated; // Si falla, volvemos a no autenticado
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _errorMessage = '';
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthErrorMessage(e.code);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
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
