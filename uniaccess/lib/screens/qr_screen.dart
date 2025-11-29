import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatelessWidget {
  final List<String> alumnos;
  final String placas;
  final String edificio;

  const QRScreen({
    super.key,
    required this.alumnos,
    required this.placas,
    required this.edificio,
  });

  @override
  Widget build(BuildContext context) {
    final Color utBlue = const Color(0xFF005A9C);
    final String qrData = 'Alumnos: ${alumnos.join(', ')}\nPlacas: $placas\nEdificio: $edificio';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Código QR Generado'),
        backgroundColor: utBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Muestra este código al personal de seguridad',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Alumnos: ${alumnos.length}'),
                Text('Placas: ${placas.isEmpty ? 'N/A' : placas}'),
                Text('Edificio: ${edificio.isEmpty ? 'N/A' : edificio}'),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Regresa al perfil
              },
              icon: const Icon(Icons.restart_alt),
              label: const Text('Nuevo Registro'),
              style: ElevatedButton.styleFrom(
                backgroundColor: utBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}