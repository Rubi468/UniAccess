import 'package:flutter/material.dart';
import 'package:uniaccess/screens/admin_qr_screen.dart'; // ✅ Importación necesaria

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  final Color utBlue = const Color(0xFF005A9C);
  final Color bisBlue = const Color(0xFF00AEEF);

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
                    const Text('Panel Administrativo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminQRScreen()),
                        );
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Escanear QR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: utBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Aquí irá la navegación a ver registros
                      },
                      icon: const Icon(Icons.assignment),
                      label: const Text('Ver Registros'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bisBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
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