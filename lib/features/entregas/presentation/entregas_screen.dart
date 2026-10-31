import 'package:flutter/material.dart';

class EntregaItem {
  final String numeroEntrega;
  final String familia;
  final String fechaHora;
  final String responsable;
  final int totalAlimentos;

  EntregaItem({
    required this.numeroEntrega,
    required this.familia,
    required this.fechaHora,
    required this.responsable,
    required this.totalAlimentos,
  });
}

class EntregasScreen extends StatefulWidget {
  const EntregasScreen({super.key});

  @override
  State<EntregasScreen> createState() => _EntregasScreenState();
}

class _EntregasScreenState extends State<EntregasScreen> {
  final List<EntregaItem> _entregas = [
    EntregaItem(
      numeroEntrega: 'ENT-2026-001',
      familia: 'Familia Pérez Gómez (Comunidad El Esfuerzo)',
      fechaHora: '2026-10-28 09:15',
      responsable: 'Encargado de Entregas',
      totalAlimentos: 3,
    ),
    EntregaItem(
      numeroEntrega: 'ENT-2026-002',
      familia: 'Familia López Morales (Comunidad Centro)',
      fechaHora: '2026-10-27 14:20',
      responsable: 'Encargado de Entregas',
      totalAlimentos: 2,
    ),
  ];

  void _mostrarFormularioNuevaEntrega() {
    final formKey = GlobalKey<FormState>();
    final numCtrl = TextEditingController(text: 'ENT-2026-003');
    final familiaCtrl = TextEditingController();
    final motivoCtrl = TextEditingController(text: 'Entrega mensual asignada');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Registrar Entrega a Familia',
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
                    decoration: const InputDecoration(labelText: 'Número de Entrega'),
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    controller: familiaCtrl,
                    decoration: const InputDecoration(labelText: 'Familia Beneficiaria / Responsable'),
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    controller: motivoCtrl,
                    decoration: const InputDecoration(labelText: 'Motivo / Observaciones'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Alimentos a entregar (FIFO - Vencimiento próximo):',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7A1C20), fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Seleccionar alimentos y verificar inventario')),
                      );
                    },
                    icon: const Icon(Icons.playlist_add, color: Color(0xFF7A1C20)),
                    label: const Text('Elegir Lotes de Alimentos', style: TextStyle(color: Color(0xFF7A1C20))),
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
                    _entregas.add(
                      EntregaItem(
                        numeroEntrega: numCtrl.text.trim(),
                        familia: familiaCtrl.text.trim(),
                        fechaHora: DateTime.now().toString().substring(0, 16),
                        responsable: 'Usuario Móvil',
                        totalAlimentos: 2,
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Entrega registrada y stock descontado automáticamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Confirmar Entrega', style: TextStyle(color: Colors.white)),
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
        title: const Text('Registro de Entregas'),
        backgroundColor: const Color(0xFF7A1C20),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _entregas.length,
        itemBuilder: (context, index) {
          final entrega = _entregas[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF7A1C20),
                child: Icon(Icons.local_shipping, color: Colors.white),
              ),
              title: Text(
                entrega.familia,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('No. ${entrega.numeroEntrega} | Fecha: ${entrega.fechaHora}\nResponsable: ${entrega.responsable}'),
              isThreeLine: true,
              trailing: Chip(
                label: Text('${entrega.totalAlimentos} items', style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.blue.shade700,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7A1C20),
        foregroundColor: Colors.white,
        onPressed: _mostrarFormularioNuevaEntrega,
        child: const Icon(Icons.add),
      ),
    );
  }
}