import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Registros'),
        backgroundColor: const Color(0xFF005A9C),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('registros')
            .orderBy('hora', descending: true) // ordena por fecha
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay registros aún',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          final registros = snapshot.data!.docs;

          return ListView.builder(
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final r = registros[index].data() as Map<String, dynamic>;

              final String estado = r['estado'] ?? 'Desconocido';
              final List<dynamic> matriculas = r['matriculas'] ?? [];
              final String placas = r['placas'] ?? 'N/A';
              final String edificio = r['edificio'] ?? 'N/A';
              final String hora = r['hora'] ?? 'N/A';

              final Color color =
                  estado == 'Verificado' ? Colors.green : Colors.red;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color,
                    child: Text(
                      '${index + 1}', // número de registro
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('$estado - ${matriculas.length} alumnos'),
                  subtitle: Text(
                    'Matrículas: ${matriculas.join(', ')}\n'
                    'Placas: $placas\n'
                    'Edificio: $edificio\n'
                    'Hora: $hora',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}