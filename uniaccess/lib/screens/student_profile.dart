import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniaccess/screens/generar_qr_screen.dart';

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

  final List<String> edificios = [
    'Edificio A', 'Edificio B', 'Edificio C', 'Edificio D',
    'Edificio E', 'Edificio F', 'Edificio G', 'Edificio H',
    'Edificio I', 'Edificio J', 'Edificio K', 'Edificio M',
  ];

  final Color utBlue = const Color(0xFF005A9C);

  Future<void> guardarYMostrarQR() async {
    final placas = placasController.text.trim();
    final edificio = edificioSeleccionado!;

    final datos = {
      'matriculas': alumnos,
      'placas': placas,
      'edificio': edificio,
      'timestamp': Timestamp.now(),
    };

    try {
      await FirebaseFirestore.instance.collection('registros').add(datos);

      if (!mounted) return; // ✅ evita usar context si el widget fue desmontado

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerarQRScreen(
            alumnos: alumnos,
            placas: placas,
            edificio: edificio,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      debugPrint('Error al guardar en Firestore: $e'); // ✅ reemplaza print
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar el registro')),
      );
    }
  }

  void validarYGenerarQR() {
    if (alumnos.isEmpty || edificioSeleccionado == null || placasController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos antes de continuar')),
      );
      return;
    }

    guardarYMostrarQR();
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
                initialValue: edificioSeleccionado, // ✅ corrección aplicada
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
                onPressed: validarYGenerarQR,
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