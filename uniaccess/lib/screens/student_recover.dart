import 'package:flutter/material.dart';

class StudentRecoverScreen extends StatelessWidget {
  const StudentRecoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color utBlue = const Color(0xFF005A9C);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
        backgroundColor: utBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ingresa tu correo institucional para recuperar tu contraseña',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                hintText: 'ejemplo@utcancun.edu.mx',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Aquí irá la lógica para enviar recuperación
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: utBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Enviar instrucciones'),
            ),
          ],
        ),
      ),
    );
  }
}