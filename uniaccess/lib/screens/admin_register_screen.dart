import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniaccess/screens/admin_login_screen.dart';

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({super.key});

  @override
  State<AdminRegisterScreen> createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController confirmarController = TextEditingController();

  final Color utBlue = const Color(0xFF005A9C);
  final String departamento = 'Seguridad de Vigilancia';

  bool esCorreoInstitucional(String correo) {
    return correo.endsWith('@utcancun.edu.mx');
  }

  Future<void> registrarAdministrador() async {
    if (_formKey.currentState!.validate()) {
      final correo = correoController.text.trim();
      final contrasena = contrasenaController.text.trim();

      try {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: correo,
          password: contrasena,
        );

        await FirebaseFirestore.instance.collection('administradores').doc(cred.user!.uid).set({
          'nombre': nombreController.text.trim(),
          'usuario': usuarioController.text.trim(),
          'correo': correo,
          'telefono': telefonoController.text.trim(),
          'departamento': departamento,
          'rol': 'administrador',
          'uid': cred.user!.uid,
          'timestamp': Timestamp.now(),
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta creada exitosamente')),
        );

        // Navegación simulada al dashboard
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboardScreen()));
      } catch (e) {
        debugPrint('Error: $e'); // ✅ reemplaza print

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crea tu cuenta administrativa'), backgroundColor: utBlue),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Nombre Completo'),
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(hintText: 'Ej: María González López'),
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 12),
              const Text('Nombre de Usuario'),
              TextFormField(
                controller: usuarioController,
                decoration: const InputDecoration(hintText: 'Ej: admin001'),
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 12),
              const Text('Correo Electrónico'),
              TextFormField(
                controller: correoController,
                decoration: const InputDecoration(hintText: 'ejemplo@utcancun.edu.mx'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo obligatorio';
                  if (!esCorreoInstitucional(value)) return 'Debe ser correo institucional';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              const Text('Teléfono'),
              TextFormField(
                controller: telefonoController,
                decoration: const InputDecoration(hintText: '998 123 4567'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 12),
              const Text('Departamento'),
              TextFormField(
                initialValue: departamento,
                enabled: false,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              const Text('Contraseña'),
              TextFormField(
                controller: contrasenaController,
                obscureText: true,
                validator: (value) => value!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 12),
              const Text('Confirmar Contraseña'),
              TextFormField(
                controller: confirmarController,
                obscureText: true,
                validator: (value) => value != contrasenaController.text ? 'Las contraseñas no coinciden' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: utBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: registrarAdministrador,
                child: const Text('Crear Cuenta'), // ✅ child al final
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                  );
                },
                child: const Text('¿Ya tienes cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}