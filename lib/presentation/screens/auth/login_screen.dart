import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_5_semestre/presentation/providers/auth_status.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // 1. Validar el formulario
    if (!_formKey.currentState!.validate()) return;

    // 2. Obtener el provider (sin escuchar cambios aquí)
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // 3. Llamar al método de inicio de sesión
    await authProvider.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    // 4. Mostrar el error si el inicio de sesión falló
    // El `AuthWrapper` se encargará de la navegación si es exitoso.
    if (mounted && authProvider.status == AuthStatus.unauthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 5. Escuchar los cambios en el AuthProvider
    final authStatus = context.watch<AuthProvider>().status;

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? 'Por favor, ingrese un correo' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Por favor, ingrese una contraseña' : null,
                ),
                const SizedBox(height: 24.0),

                // 6. Cambiar el botón según el estado de autenticación
                if (authStatus == AuthStatus.uninitialized) // 'uninitialized' se usa para "cargando"
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Entrar'),
                  ),

                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
