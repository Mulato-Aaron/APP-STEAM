
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  User? get currentUser => _user;

  bool _isLogin = true;
  bool get isLogin => _isLogin;

  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> _handleAuthRequest(Future<UserCredential> Function() authFunction, BuildContext context) async {
    try {
      await authFunction();
      return true;
    } on FirebaseAuthException catch (e) {
      developer.log(
        'Error de autenticación de Firebase',
        name: 'auth.firebase',
        error: e,
        stackTrace: StackTrace.current,
      );
      
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No se encontró un usuario con ese correo electrónico.';
          break;
        case 'wrong-password':
          message = 'La contraseña es incorrecta.';
          break;
        case 'email-already-in-use':
          message = 'El correo electrónico ya está en uso por otra cuenta.';
          break;
        case 'weak-password':
          message = 'La contraseña es demasiado débil.';
          break;
        case 'operation-not-allowed':
          message = 'El inicio de sesión por correo electrónico y contraseña no está habilitado.';
          break;
        default:
          message = 'Ocurrió un error inesperado. Por favor, inténtelo de nuevo.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } catch (e) {
      developer.log(
        'Error de autenticación genérico',
        name: 'auth.generic',
        error: e,
        stackTrace: StackTrace.current,
      );
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error. Por favor, inténtelo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    await _handleAuthRequest(() => _auth.signInWithEmailAndPassword(email: email, password: password), context);
  }

  Future<void> createUserWithEmailAndPassword(BuildContext context, String email, String password) async {
    await _handleAuthRequest(() => _auth.createUserWithEmailAndPassword(email: email, password: password), context);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
