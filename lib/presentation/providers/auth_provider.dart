
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'auth_status.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String _errorMessage = '';
  bool _isAdmin = false;
  AuthStatus _status = AuthStatus.uninitialized;

  User? get user => _user; // Renombrado de currentUser a user
  String get errorMessage => _errorMessage;
  bool get isAdmin => _isAdmin;
  AuthStatus get status => _status;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
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
      final idTokenResult = await _user!.getIdTokenResult(true); // Forzar la actualización del token
      final claims = idTokenResult.claims;
      _isAdmin = claims != null && claims['admin'] == true;
    } catch (e) {
      _isAdmin = false;
      // Considera registrar este error en lugar de mostrarlo al usuario directamente
      // a menos que sea un error crítico que deba conocer.
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _errorMessage = '';
      _status = AuthStatus.uninitialized; // Mostrar carga mientras se loguea
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // El listener _onAuthStateChanged se encargará del resto.
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthErrorMessage(e.code);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _errorMessage = '';
      _status = AuthStatus.uninitialized;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(email: email, password: password);
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
    // El listener _onAuthStateChanged se encargará de actualizar el estado.
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
