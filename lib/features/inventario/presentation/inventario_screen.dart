import 'package:flutter/material.dart';

class InventarioItem {
  final String codigoAlimento;
  final String nombreAlimento;
  final String lote;
  final double cantidadDisponible;
  final String unidadMedida;
  final String fechaVencimiento;
  final String ubicacion;
  final String estado; // 'Disponible', 'Por vencer', 'Vencido'

  InventarioItem({
    required this.codigoAlimento,
    required this.nombreAlimento,
    required this.lote,
    required this.cantidadDisponible,
    required this.unidadMedida,
    required this.fechaVencimiento,
    required this.ubicacion,
    required this.estado,
  });
}

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  // Lista de prueba para simular el inventario con lotes y vencimientos
  final List<InventarioItem> _inventario = [
    InventarioItem(
      codigoAlimento: 'AL-001',
      nombreAlimento: 'Arroz blanco',
      lote: 'LOT-ARZ-501',
      cantidadDisponible: 450.0,
      unidadMedida: 'Kilogramos',
      fechaVencimiento: '2026-12-15',
      ubicacion: 'Estante A - Fila 2',
      estado: 'Disponible',
    ),
    InventarioItem(
      codigoAlimento: 'AL-003',
      nombreAlimento: 'Aceite vegetal',
      lote: 'LOT-ACE-102',
      cantidadDisponible: 18.0,
      unidadMedida: 'Litros',
      fechaVencimiento: '2026-11-02', // Próximo a vencer
      ubicacion: 'Estante B - Fila 1',
      estado: 'Por vencer',
    ),
    InventarioItem(
      codigoAlimento: 'AL-002',
      nombreAlimento: 'Frijol negro',
      lote: 'LOT-FRJ-303',
      cantidadDisponible: 5.0,
      unidadMedida: 'Kilogramos',
      fechaVencimiento: '2026-09-10', // Vencido
      ubicacion: 'Estante A - Fila 4',
      estado: 'Vencido',
    ),
  ];

  String _filtroEstado = 'Todos';

  Color _obtenerColorEstado(String estado) {
    switch (estado) {
      case 'Disponible':
        return Colors.green;
      case 'Por vencer':
        return Colors.orange;
      case 'Vencido':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventarioFiltrado = _inventario.where((item) {
      if (_filtroEstado == 'Todos') return true;
      return item.estado == _filtroEstado;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario y Vencimientos'),
        backgroundColor: const Color(0xFF7A1C20),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filtros rápidos por estado
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Todos', 'Disponible', 'Por vencer', 'Vencido'].map((estado) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(estado),
                      selected: _filtroEstado == estado,
                      selectedColor: const Color(0xFF7A1C20).withValues(alpha: 0.1),
                      labelStyle: TextStyle(
                        color: _filtroEstado == estado ? const Color(0xFF7A1C20) : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _filtroEstado = estado;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Lista de Inventario
          Expanded(
            child: ListView.builder(
              itemCount: inventarioFiltrado.length,
              itemBuilder: (context, index) {
                final item = inventarioFiltrado[index];
                final colorEstado = _obtenerColorEstado(item.estado);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.nombreAlimento,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Chip(
                              label: Text(item.estado, style: const TextStyle(color: Colors.white, fontSize: 11)),
                              backgroundColor: colorEstado,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Lote: ${item.lote} | Ubicación: ${item.ubicacion}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Disponible: ${item.cantidadDisponible} ${item.unidadMedida}',
                              style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF7A1C20)),
                            ),
                            Text(
                              'Vence: ${item.fechaVencimiento}',
                              style: TextStyle(fontWeight: FontWeight.bold, color: colorEstado, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}