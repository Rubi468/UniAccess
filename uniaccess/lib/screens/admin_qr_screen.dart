import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AdminQRScreen extends StatefulWidget {
  const AdminQRScreen({super.key});

  @override
  State<AdminQRScreen> createState() => _AdminQRScreenState();
}

class _AdminQRScreenState extends State<AdminQRScreen> {
  String? resultado;

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
        child: Column(
          children: [
            const SizedBox(height: 48),
            const Text(
              'Escanear Código QR',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final barcode = capture.barcodes.first;
                  final code = barcode.rawValue;
                  if (code != null) {
                    setState(() {
                      resultado = code;
                    });
                    // Aquí podrías navegar o guardar el resultado
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => ResultadoScreen(data: code)));
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  resultado = 'DEMO-QR-123456';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: utBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Simular Escaneo (Demo)'), // ← child al final
            ),
            const SizedBox(height: 24),
            if (resultado != null)
              Text('Resultado: $resultado', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}