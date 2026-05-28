import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange, Colors.red],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Registro',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(fontSize: 16)
                        ),
                        onPressed: () {
                          authProvider.createUserWithEmailAndPassword(
                            context, // Pasamos el contexto
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        },
                        child: const Text('Registrar'),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          // Usamos el provider para cambiar el estado
                          context.read<AuthProvider>().isLogin = true;
                        },
                        child: const Text('¿Ya tienes una cuenta? Inicia sesión'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
