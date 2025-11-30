import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniaccess/screens/admin_login_screen.dart';

class AdminRecoverScreen extends StatefulWidget {
  const AdminRecoverScreen({super.key});

  @override
  State<AdminRecoverScreen> createState() => _AdminRecoverScreenState();
}

class _AdminRecoverScreenState extends State<AdminRecoverScreen> {
  final TextEditingController correoController = TextEditingController();
  final Color utBlue = const Color(0xFF005A9C);
  final Color bisBlue = const Color(0xFF00AEEF);

  Future<void> enviarInstrucciones() async {
    final input = correoController.text.trim();
    final correo = input.contains('@') ? input : '$input@utcancun.edu.mx';

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: correo);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Instrucciones enviadas al correo')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Recuperar Contraseña', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Icon(Icons.shield, size: 48, color: Color(0xFF005A9C)),
                    const SizedBox(height: 8),
                    const Text('Personal Administrativo', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    const Text(
                      'Ingresa tu usuario o correo y te enviaremos un enlace para restablecer tu contraseña',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: correoController,
                      decoration: const InputDecoration(
                        labelText: 'Usuario o Correo',
                        hintText: 'Ej: admin001 o correo@utcancun.edu.mx',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: enviarInstrucciones,
                      child: const Text('Enviar Instrucciones'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: utBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '💡 Si no recibes el correo en unos minutos, verifica tu correo basura o contacta con soporte técnico',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                        );
                      },
                      child: const Text('← Volver al inicio de sesión'),
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