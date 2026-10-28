import 'package:flutter/material.dart';

class DonacionItem {
  final String numeroDonacion;
  final String donante;
  final String fecha;
  final String tipoDonacion;
  final int totalAlimentos;

  DonacionItem({
    required this.numeroDonacion,
    required this.donante,
    required this.fecha,
    required this.tipoDonacion,
    required this.totalAlimentos,
  });
}

class DonacionesScreen extends StatefulWidget {
  const DonacionesScreen({super.key});

  @override
  State<DonacionesScreen> createState() => _DonacionesScreenState();
}

class _DonacionesScreenState extends State<DonacionesScreen> {
  // Lista de prueba para simular donaciones registradas
  final List<DonacionItem> _donaciones = [
    DonacionItem(
      numeroDonacion: 'DON-2026-001',
      donante: 'Supermercado La Torre',
      fecha: '2026-10-28 10:30',
      tipoDonacion: 'Empresa',
      totalAlimentos: 3,
    ),
    DonacionItem(
      numeroDonacion: 'DON-2026-002',
      donante: 'Comité de Vecinos Zona 1',
      fecha: '2026-10-27 15:45',
      tipoDonacion: 'Grupo Comunitario',
      totalAlimentos: 2,
    ),
  ];

  void _mostrarFormularioNuevaDonacion() {
    final formKey = GlobalKey<FormState>();
    final numCtrl = TextEditingController(text: 'DON-2026-003');
    final donanteCtrl = TextEditingController();
    String tipoSeleccionado = 'Empresa';
    final tipos = ['Particular', 'Empresa', 'Institución', 'Grupo Comunitario', 'Anónima'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Registrar Donación',
            style: TextStyle(color: Color(0xFF7A1C20), fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: numCtrl,
                    decoration: const InputDecoration(labelText: 'Número de Donación'),
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    controller: donanteCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre del Donante / Razón Social'),
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: tipoSeleccionado,
                    decoration: const InputDecoration(labelText: 'Tipo de Donación'),
                    items: tipos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) => tipoSeleccionado = val!,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Lotes y Alimentos:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7A1C20)),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Aquí se abriría el selector de múltiples alimentos y lotes
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ventana para agregar alimentos al lote')),
                      );
                    },
                    icon: const Icon(Icons.add_box, color: Color(0xFF7A1C20)),
                    label: const Text('Agregar Alimentos al Lote', style: TextStyle(color: Color(0xFF7A1C20))),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A1C20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    _donaciones.add(
                      DonacionItem(
                        numeroDonacion: numCtrl.text.trim(),
                        donante: donanteCtrl.text.trim(),
                        fecha: DateTime.now().toString().substring(0, 16),
                        tipoDonacion: tipoSeleccionado,
                        totalAlimentos: 1, // Simulado
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Donación registrada e inventario actualizado'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Confirmar y Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Donaciones'),
        backgroundColor: const Color(0xFF7A1C20),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _donaciones.length,
        itemBuilder: (context, index) {
          final donacion = _donaciones[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF7A1C20),
                child: Icon(Icons.volunteer_activism, color: Colors.white),
              ),
              title: Text(
                donacion.donante,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('No. ${donacion.numeroDonacion} | Fecha: ${donacion.fecha}\nTipo: ${donacion.tipoDonacion}'),
              isThreeLine: true,
              trailing: Chip(
                label: Text('${donacion.totalAlimentos} items', style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.green.shade700,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7A1C20),
        foregroundColor: Colors.white,
        onPressed: _mostrarFormularioNuevaDonacion,
        child: const Icon(Icons.add),
      ),
    );
  }
}