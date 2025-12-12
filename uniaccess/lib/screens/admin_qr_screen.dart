import 'dart:convert'; // para jsonDecode
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'confirmacion_screen.dart'; // Importa la pantalla de confirmación

class AdminQRScreen extends StatefulWidget {
  const AdminQRScreen({super.key});

  @override
  State<AdminQRScreen> createState() => _AdminQRScreenState();
}

class _AdminQRScreenState extends State<AdminQRScreen> {
  final Color utBlue = const Color(0xFF005A9C);
  final Color bisBlue = const Color(0xFF00AEEF);

  /// Función para navegar a la pantalla de confirmación
  void _navegarConQR(String code) {
    try {
      // Intentamos decodificar el contenido como JSON
      final Map<String, dynamic> datos = jsonDecode(code);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmacionScreen(datosQR: datos),
        ),
      );
    } catch (e) {
      // Si no es JSON válido, lo pasamos como texto plano
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmacionScreen(datosQR: {"codigo": code}),
        ),
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
        child: Column(
          children: [
            const SizedBox(height: 48),
            const Text(
              'Escanear Código QR',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            /// Escáner QR
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final barcode = capture.barcodes.first;
                  final code = barcode.rawValue;
                  if (code != null) {
                    _navegarConQR(code);
                  }
                },
              ),
            ),

            const SizedBox(height: 12),
            const Text(
              'Coloca el código QR dentro del marco',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            /// Botón de simulación con JSON demo
            ElevatedButton(
              onPressed: () {
                final demoJson = jsonEncode({
                  "matriculas": ["2021001234", "2021005678"],
                  "placas": "ABC-123-XYZ",
                  "edificio": "Edificio A",
                });
                _navegarConQR(demoJson);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: utBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Simular Escaneo (Demo)'),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}