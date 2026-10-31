import 'package:flutter/material.dart';
import 'package:eco_comunidad/features/alimentos/presentation/alimentos_screen.dart';
import 'package:eco_comunidad/features/donaciones/presentation/donaciones_screen.dart';
import 'package:eco_comunidad/features/inventario/presentation/inventario_screen.dart';
import 'package:eco_comunidad/features/entregas/presentation/entregas_screen.dart';
import 'package:eco_comunidad/features/trazabilidad/presentation/historial_bajas_screen.dart'; 
import 'package:eco_comunidad/features/reportes/presentation/reportes_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String username;
  final String role; //'Administrador', 'Almacén', 'Entregas', 'Coordinador'

  const DashboardScreen({
    super.key,
    required this.username,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoComunidad - $role'),
        backgroundColor: const Color(0xFF7A1C20),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF7A1C20),
              ),
              accountName: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text('Rol: $role'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF7A1C20), size: 40),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF7A1C20)),
              title: const Text('Panel Principal'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(

              leading: const Icon(Icons.inventory, color: Color(0xFF7A1C20)),
              title: const Text('Catálogo de Alimentos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AlimentosScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard, color: Color(0xFF7A1C20)),
              title: const Text('Donaciones'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DonacionesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_outlined, color: Color(0xFF7A1C20)),
              title: const Text('Inventario'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InventarioScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.family_restroom, color: Color(0xFF7A1C20)),
              title: const Text('Familias Beneficiarias'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntregasScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.heart_broken, color: Color(0xFF7A1C20)),
              title: const Text('Bajas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistorialBajasScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_outlined, color: Color(0xFF7A1C20)),
              title: const Text('Reportes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportesScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                
                
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de Bienvenida / Estadísticas rápidas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF7A1C20),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen del Sistema',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '1,245 kg',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Alimentos disponibles en almacén',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                  Icon(Icons.warehouse, color: Colors.white54, size: 50),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Módulos Principales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 244, 241, 241),
              ),
            ),
            const SizedBox(height: 12),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildModuleCard(context, 'Alimentos', Icons.fastfood, Colors.orange),
                _buildModuleCard(context, 'Donaciones', Icons.volunteer_activism, Colors.green),
                _buildModuleCard(context, 'Inventario', Icons.inventory_2, Colors.blue),
                _buildModuleCard(context, 'Familias', Icons.people, Colors.purple),
                _buildModuleCard(context, 'Entregas', Icons.local_shipping, Colors.teal),
                _buildModuleCard(context, 'Bajas', Icons.warning, Colors.redAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Abriendo módulo de $title...')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.1),
                radius: 28,
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}