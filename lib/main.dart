import 'package:flutter/material.dart';
// Importa tu nueva pantalla (asegúrate de que la ruta coincida con la de tu proyecto)
import 'features/dashboard/presentation/dashboard_screen.dart';

void main() {
  runApp(const EcoComunidadApp());
}

class EcoComunidadApp extends StatelessWidget {
  const EcoComunidadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoComunidad Móvil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF7A1C20), // Tono vinotinto corporativo
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7A1C20),
          primary: const Color(0xFF7A1C20),
        ),
        scaffoldBackgroundColor: const Color(0xFF7A1C20), // Fondo general a juego
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  void _fLogin() {
    final usuario = _userController.text.trim();
    final password = _passController.text.trim();

    if (usuario.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa usuario y contraseña'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return; 
    }

    setState(() => _isLoading = true);

    // Simulación de autenticación (Aquí conectaremos con la API REST en el Bloque 13)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; 

      setState(() => _isLoading = false);
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
          username: usuario,
          role: 'Administrador', // Aquí puedes cambiar el rol según la lógica de tu aplicación
        ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logotipo institucional desde los assets
                  Image.asset(
                    'assets/images/logo.png',
                    width: 120,  // Ajusta el ancho según lo necesites
                    height: 120, // Ajusta el alto según lo necesites
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'EcoComunidad',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A1C20),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Campo de Usuario
                  TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF7A1C20)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de Contraseña
                  TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF7A1C20)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botón Iniciar Sesión
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A1C20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _fLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'INICIAR SESIÓN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
