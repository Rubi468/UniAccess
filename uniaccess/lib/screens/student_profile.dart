import 'package:flutter/material.dart';
import 'package:uniaccess/screens/qr_screen.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController placasController = TextEditingController();
  final List<String> alumnos = [];
  String? edificioSeleccionado;

  // Lista de edificios tal cual me la diste
  final List<String> edificios = [
    'Edificio A',
    'Edificio B',
    'Edificio C',
    'Edificio D',
    'Edificio E',
    'Edificio F',
    'Edificio G',
    'Edificio H',
    'Edificio I',
    'Edificio J',
    'Edificio K',
    'Edificio M',
  ];

  final Color utBlue = const Color(0xFF005A9C);

  void generarQR() {
    if (alumnos.isEmpty || edificioSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un alumno y selecciona un edificio')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScreen(
          alumnos: alumnos,
          placas: placasController.text.trim(),
          edificio: edificioSeleccionado ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Entrada'),
        backgroundColor: utBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Matrículas de Alumnos', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextField(
                controller: matriculaController,
                decoration: const InputDecoration(
                  hintText: 'Ej: 2021001234',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  final matricula = matriculaController.text.trim();
                  if (matricula.isNotEmpty) {
                    setState(() {
                      alumnos.add(matricula);
                      matriculaController.clear();
                    });
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Agregar Alumno'),
                style: ElevatedButton.styleFrom(backgroundColor: utBlue),
              ),
              const SizedBox(height: 16),
              const Text('Placas del Automóvil', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextField(
                controller: placasController,
                decoration: const InputDecoration(
                  hintText: 'Ej: ABC-123-XYZ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Edificio Destino', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: edificioSeleccionado,
                items: edificios.map((edificio) {
                  return DropdownMenuItem(
                    value: edificio,
                    child: Text(edificio),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    edificioSeleccionado = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Seleccionar edificio...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: generarQR,
                icon: const Icon(Icons.qr_code),
                label: const Text('Generar Código QR'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: utBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}