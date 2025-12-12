import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard_screen.dart';

class ConfirmacionScreen extends StatefulWidget {
  final Map<String, dynamic> datosQR;

  const ConfirmacionScreen({super.key, required this.datosQR});

  @override
  State<ConfirmacionScreen> createState() => _ConfirmacionScreenState();
}

class _ConfirmacionScreenState extends State<ConfirmacionScreen> {
  Future<void> _guardarRegistro(String estado) async {
    await FirebaseFirestore.instance.collection('registros').add({
      'matriculas': widget.datosQR['matriculas'] ?? [],
      'placas': widget.datosQR['placas'] ?? 'N/A',
      'edificio': widget.datosQR['edificio'] ?? 'N/A',
      'estado': estado,
      'hora': DateTime.now().toIso8601String(),
    });

    if (!mounted) return; // ✅ Verifica que el widget sigue montado

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> matriculas = widget.datosQR['matriculas'] ?? [];
    final String placas = widget.datosQR['placas'] ?? 'N/A';
    final String edificio = widget.datosQR['edificio'] ?? 'N/A';

    return Scaffold(
      backgroundColor: const Color(0xFF005A9C),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            const Text(
              'Verificar Entrada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            /// Contenedor con datos dinámicos del QR
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Matrículas:\n${matriculas.join(', ')}\n\n'
                'Placas: $placas\n'
                'Edificio: $edificio',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Verifica físicamente que la información coincida',
              style: TextStyle(color: Colors.yellowAccent),
            ),
            const Spacer(),

            /// Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _guardarRegistro('Rechazado'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Rechazar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _guardarRegistro('Verificado'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Verificar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}