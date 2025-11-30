import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerarQRScreen extends StatelessWidget {
  final List<String> alumnos;
  final String placas;
  final String edificio;

  const GenerarQRScreen({
    super.key,
    required this.alumnos,
    required this.placas,
    required this.edificio,
  });

  Future<void> guardarRegistro() async {
    final datos = {
      'matriculas': alumnos,
      'placas': placas,
      'edificio': edificio,
      'timestamp': Timestamp.now(),
    };

    try {
      await FirebaseFirestore.instance.collection('registros').add(datos);
    } catch (e) {
      debugPrint('Error al guardar en Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generamos el string para el QR
    final datosQR = jsonEncode({
      'matriculas': alumnos,
      'placas': placas.isEmpty ? 'N/A' : placas,
      'edificio': edificio.isEmpty ? 'N/A' : edificio,
    });

    // Guardamos en Firestore al entrar a esta pantalla
    guardarRegistro();

    return Scaffold(
      appBar: AppBar(title: const Text('Código QR Generado')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Muestra este código al personal de seguridad',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              QrImageView(
                data: datosQR,
                version: QrVersions.auto,
                size: 250.0,
              ),
              const SizedBox(height: 20),
              Text('Alumnos: ${alumnos.length}'),
              Text('Placas: ${placas.isEmpty ? 'N/A' : placas}'),
              Text('Edificio: ${edificio.isEmpty ? 'N/A' : edificio}'),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.restart_alt),
                label: const Text('Nuevo Registro'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}