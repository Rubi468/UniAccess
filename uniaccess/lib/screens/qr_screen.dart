import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatefulWidget {
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
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  late final String qrData;

  @override
  void initState() {
    super.initState();
    qrData = _generarDatosQR();
    _guardarRegistro();
  }

  /// Genera los datos en formato JSON para el QR
  String _generarDatosQR() {
    final datos = {
      'matriculas': widget.alumnos,
      'placas': widget.placas.isEmpty ? 'N/A' : widget.placas,
      'edificio': widget.edificio.isEmpty ? 'N/A' : widget.edificio,
    };
    return jsonEncode(datos);
  }

  /// Guarda un único registro en Firestore con todos los datos
  Future<void> _guardarRegistro() async {
    final datos = {
      'matriculas': widget.alumnos,
      'placas': widget.placas,
      'edificio': widget.edificio,
      'timestamp': Timestamp.now(),
    };

    try {
      await FirebaseFirestore.instance.collection('registros').add(datos);

      // No hay uso de context aquí, así que no hay problema
    } catch (e) {
      debugPrint('Error al guardar en Firestore: $e');

      if (!mounted) return; // ✅ Verifica que el widget sigue montado

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar el registro')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Código QR generado')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250.0,
              ),
              const SizedBox(height: 20),
              const Text(
                'Registros guardados correctamente',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text('Alumnos: ${widget.alumnos.length}'),
              Text('Placas: ${widget.placas.isEmpty ? 'N/A' : widget.placas}'),
              Text('Edificio: ${widget.edificio.isEmpty ? 'N/A' : widget.edificio}'),
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