import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerarQRScreen extends StatefulWidget {
  final List<String> alumnos;
  final String placas;
  final String edificio;

  const GenerarQRScreen({
    super.key,
    required this.alumnos,
    required this.placas,
    required this.edificio,
  });

  @override
  State<GenerarQRScreen> createState() => _GenerarQRScreenState();
}

class _GenerarQRScreenState extends State<GenerarQRScreen> {
  @override
  void initState() {
    super.initState();
    _guardarRegistro(); // ✅ Se guarda solo una vez al entrar
  }

  Future<void> _guardarRegistro() async {
    final datos = {
      'matriculas': widget.alumnos,
      'placas': widget.placas.isEmpty ? 'N/A' : widget.placas,
      'edificio': widget.edificio.isEmpty ? 'N/A' : widget.edificio,
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
    // Generamos el string JSON para el QR
    final datosQR = jsonEncode({
      'matriculas': widget.alumnos,
      'placas': widget.placas.isEmpty ? 'N/A' : widget.placas,
      'edificio': widget.edificio.isEmpty ? 'N/A' : widget.edificio,
    });

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

              /// QR generado con JSON
              QrImageView(
                data: datosQR,
                version: QrVersions.auto,
                size: 250.0,
              ),

              const SizedBox(height: 20),
              Text('Alumnos: ${widget.alumnos.length}'),
              Text('Placas: ${widget.placas.isEmpty ? 'N/A' : widget.placas}'),
              Text('Edificio: ${widget.edificio.isEmpty ? 'N/A' : widget.edificio}'),

              const SizedBox(height: 40),

              /// Botón para volver y crear otro registro
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