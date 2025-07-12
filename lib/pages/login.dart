import 'package:flutter/material.dart';
import 'package:mealit/pages/home.dart';
import '../entity/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  final AuthRepository authRepository;

  const LoginScreen({super.key, required this.authRepository});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum AuthMode { login, signup }

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late AuthRepository _authRepo;
  AuthMode _authMode = AuthMode.login;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _authRepo = widget.authRepository;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    bool success = false;

    if (_authMode == AuthMode.login) {
      // Solo verificar, no volver a guardar si ya está registrado
      success = _authRepo.verifyCredentials(email, password);
      if (!success) {
        _error = 'Correo o contraseña incorrectos';
      }
    } else {
      // Registro: guardar usuario nuevo
      success = await _authRepo.login(username, email, password);
      if (!success) {
        _error = 'Error al registrar usuario';
      }
    }

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      if (_error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_error!)),
        );
      }
    }
  }

  void _switchAuthMode() {
    setState(() {
      _authMode = _authMode == AuthMode.login ? AuthMode.signup : AuthMode.login;
      _error = null;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceBright,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _authMode == AuthMode.login
                          ? 'Iniciar sesión en MealIt'
                          : 'Registrar usuario en MealIt',
                      style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    if (_authMode == AuthMode.signup)
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de usuario',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un nombre de usuario';
                          }
                          return null;
                        },
                      ),
                    if (_authMode == AuthMode.signup) const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Ingrese un correo';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Ingrese un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Ingrese una contraseña';
                        if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(_authMode == AuthMode.login ? 'Iniciar sesión' : 'Registrar'),
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading ? null : _switchAuthMode,
                      child: Text(_authMode == AuthMode.login
                          ? '¿No tienes cuenta? Regístrate'
                          : '¿Ya tienes cuenta? Inicia sesión'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
