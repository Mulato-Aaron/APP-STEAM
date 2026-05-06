import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (_isLogin) {
        await authService.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        await authService.signUpWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_isLogin ? 'Login' : 'Sign Up', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value!.isEmpty || !value.contains('@') ? 'Invalid email' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty || value.length < 6 ? 'Password is too short' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _submit, child: Text(_isLogin ? 'Login' : 'Sign Up')),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin ? 'Create an account' : 'I already have an account'),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<AuthService>(context, listen: false).signInAnonymously();
                  },
                  child: const Text('Continue anonymously'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
