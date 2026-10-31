import 'package:flutter/material.dart';

class MovimientoHistorial {
  final String tipo; // 'Entrada', 'Entrega', 'Baja'
  final String referencia;
  final String alimento;
  final String lote;
  final double cantidad;
  final String fecha;
  final String responsable;
  final String motivoODetalle;

  MovimientoHistorial({
    required this.tipo,
    required this.referencia,
    required this.alimento,
    required this.lote,
    required this.cantidad,
    required this.fecha,
    required this.responsable,
    required this.motivoODetalle,
  });
}

class HistorialBajasScreen extends StatefulWidget {
  const HistorialBajasScreen({super.key});

  @override
  State<HistorialBajasScreen> createState() => _HistorialBajasScreenState();
}

class _HistorialBajasScreenState extends State<HistorialBajasScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<MovimientoHistorial> _historial = [
    MovimientoHistorial(
      tipo: 'Entrada',
      referencia: 'DON-2026-001',
      alimento: 'Arroz blanco',
      lote: 'LOT-ARZ-501',
      cantidad: 500.0,
      fecha: '2026-10-28 10:30',
      responsable: 'Encargado Almacén',
      motivoODetalle: 'Donación de Supermercado La Torre',
    ),
    MovimientoHistorial(
      tipo: 'Entrega',
      referencia: 'ENT-2026-001',
      alimento: 'Arroz blanco',
      lote: 'LOT-ARZ-501',
      cantidad: 50.0,
      fecha: '2026-10-28 09:15',
      responsable: 'Encargado Entregas',
      motivoODetalle: 'Entregado a Familia Pérez Gómez',
    ),
  ];

  final List<MovimientoHistorial> _bajas = [
    MovimientoHistorial(
      tipo: 'Baja',
      referencia: 'BAJA-2026-001',
      alimento: 'Aceite vegetal',
      lote: 'LOT-ACE-102',
      cantidad: 2.0,
      fecha: '2026-10-27 16:00',
      responsable: 'Encargado Almacén',
      motivoODetalle: 'Empaque dañado durante descarga',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _mostrarFormularioNuevaBaja() {
    final formKey = GlobalKey<FormState>();
    final loteCtrl = TextEditingController();
    final cantidadCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String motivoSeleccionado = 'Empaque dañado';
    final motivos = ['Vencimiento', 'Empaque dañado', 'Contaminación', 'Pérdida', 'Error de registro', 'Otro'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Registrar Baja de Alimento',
            style: TextStyle(color: Color(0xFF7A1C20), fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: loteCtrl,
                    decoration: const InputDecoration(labelText: 'Número de Lote (ej: LOT-ACE-102)'),
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    controller: cantidadCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad a dar de baja'),
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: motivoSeleccionado,
                    decoration: const InputDecoration(labelText: 'Motivo de la Baja'),
                    items: motivos.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) => motivoSeleccionado = val!,
                  ),
                  TextFormField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: 'Observaciones / Evidencia'),
                    maxLines: 2,
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
                    _bajas.add(
                      MovimientoHistorial(
                        tipo: 'Baja',
                        referencia: 'BAJA-2026-002',
                        alimento: 'Alimento en lote ${loteCtrl.text}',
                        lote: loteCtrl.text.trim(),
                        cantidad: double.tryParse(cantidadCtrl.text) ?? 0.0,
                        fecha: DateTime.now().toString().substring(0, 16),
                        responsable: 'Usuario Móvil',
                        motivoODetalle: motivoSeleccionado,
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Baja registrada y stock actualizado en historial'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Confirmar Baja', style: TextStyle(color: Colors.white)),
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
        title: const Text('Historial y Bajas de Alimentos'),
        backgroundColor: const Color(0xFF7A1C20),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Historial y Trazabilidad', icon: Icon(Icons.history)),
            Tab(text: 'Registro de Bajas', icon: Icon(Icons.warning_amber)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: _historial.length,
            itemBuilder: (context, index) {
              final item = _historial[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.tipo == 'Entrada' ? Colors.green.shade100 : Colors.blue.shade100,
                    child: Icon(
                      item.tipo == 'Entrada' ? Icons.login : Icons.local_shipping,
                      color: item.tipo == 'Entrada' ? Colors.green.shade800 : Colors.blue.shade800,
                    ),
                  ),
                  title: Text('${item.alimento} (${item.cantidad})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Ref: ${item.referencia} | Lote: ${item.lote}\n${item.motivoODetalle}\nFecha: ${item.fecha}'),
                  isThreeLine: true,
                ),
              );
            },
          ),        

          ListView.builder(
            itemCount: _bajas.length,
            itemBuilder: (context, index) {
              final item = _bajas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.block, color: Colors.white),
                  ),
                  title: Text('${item.alimento} (-${item.cantidad})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Lote: ${item.lote} | Motivo: ${item.motivoODetalle}\nResponsable: ${item.responsable} | Fecha: ${item.fecha}'),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7A1C20),
        foregroundColor: Colors.white,
        onPressed: _mostrarFormularioNuevaBaja,
        child: const Icon(Icons.remove_circle_outline),
      ),
    );
  }
}