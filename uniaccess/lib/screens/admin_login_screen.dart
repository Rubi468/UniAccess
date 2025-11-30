import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniaccess/screens/admin_register_screen.dart';
import 'package:uniaccess/screens/admin_recover_screen.dart';
import 'package:uniaccess/screens/admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  final Color utBlue = const Color(0xFF005A9C);
  final Color bisBlue = const Color(0xFF00AEEF);

  Future<void> iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      try {
        final correo = '${usuarioController.text.trim()}@utcancun.edu.mx';

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: correo,
          password: contrasenaController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso')),
        );

        // ✅ Navegación al Panel Administrativo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005A9C), Color(0xFF00AEEF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Inicio de Sesión', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Personal Administrativo', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: usuarioController,
                        decoration: const InputDecoration(
                          labelText: 'Usuario',
                          hintText: 'Ej: admin001',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: contrasenaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: iniciarSesion,
                        child: const Text('Iniciar Sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: utBlue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AdminRecoverScreen()),
                          );
                        },
                        child: const Text('¿Olvidaste tu contraseña?'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AdminRegisterScreen()),
                          );
                        },
                        child: const Text('¿No tienes cuenta? Regístrate aquí'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Acceso restringido solo para personal autorizado',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
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