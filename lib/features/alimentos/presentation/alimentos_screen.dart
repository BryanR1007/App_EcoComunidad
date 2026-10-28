import 'package:flutter/material.dart';


class AlimentoItem {
  final String codigo;
  final String nombre;
  final String categoria;
  final String unidadMedida;
  final String presentacion;

  AlimentoItem({
    required this.codigo,
    required this.nombre,
    required this.categoria,
    required this.unidadMedida,
    required this.presentacion,
  });
}

class AlimentosScreen extends StatefulWidget {
  const AlimentosScreen({super.key});

  @override
  State<AlimentosScreen> createState() => _AlimentosScreenState();
}

class _AlimentosScreenState extends State<AlimentosScreen> {
  // Lista temporal de prueba (simulando los datos que vendrán de la API MySQL)
  final List<AlimentoItem> _alimentos = [
    AlimentoItem(codigo: 'AL-001', nombre: 'Arroz blanco', categoria: 'Granos', unidadMedida: 'Kilogramos', presentacion: 'Saco 50kg'),
    AlimentoItem(codigo: 'AL-002', nombre: 'Frijol negro', categoria: 'Granos', unidadMedida: 'Kilogramos', presentacion: 'Saco 50kg'),
    AlimentoItem(codigo: 'AL-003', nombre: 'Aceite vegetal', categoria: 'Aceites', unidadMedida: 'Litros', presentacion: 'Botella 1L'),
    AlimentoItem(codigo: 'AL-004', nombre: 'Pasta en tiras', categoria: 'Pastas', unidadMedida: 'Gramos', presentacion: 'Paquete 500g'),
  ];

  String _filtroBusqueda = '';

  @override
  Widget build(BuildContext context) {
    final alimentosFiltrados = _alimentos.where((alimento) {
      return alimento.nombre.toLowerCase().contains(_filtroBusqueda.toLowerCase()) ||
          alimento.categoria.toLowerCase().contains(_filtroBusqueda.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Alimentos'),
        backgroundColor: const Color(0xFF7A1C20),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barra de Búsqueda y Filtros
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _filtroBusqueda = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Buscar por nombre o categoría...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF7A1C20)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          
          // Lista de Alimentos
          Expanded(
            child: ListView.builder(
              itemCount: alimentosFiltrados.length,
              itemBuilder: (context, index) {
                final alimento = alimentosFiltrados[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF7A1C20).withValues(alpha: 0.1),
                      child: const Icon(Icons.fastfood, color: Color(0xFF7A1C20)),
                    ),
                    title: Text(
                      alimento.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Cat: ${alimento.categoria} | Presentación: ${alimento.presentacion}'),
                    trailing: Chip(
                      label: Text(
                        alimento.codigo,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: const Color(0xFF7A1C20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7A1C20),
        foregroundColor: Colors.white,
        // Aquí abriremos el formulario para registrar un nuevo alimento (Bloque 5)
        onPressed: _mostrarFormularioNuevoAlimento,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  void _mostrarFormularioNuevoAlimento() {
    final formKey = GlobalKey<FormState>();
    final codigoCtrl = TextEditingController();
    final nombreCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final presentacionCtrl = TextEditingController();
    
    String categoriaSeleccionada = 'Granos';
    String unidadSeleccionada = 'Kilogramos';

    final categorias = [
      'Granos', 'Cereales', 'Enlatados', 'Pastas', 
      'Harinas', 'Aceites', 'Bebidas', 'Alimentos infantiles', 'Otros'
    ];

    final unidades = ['Kilogramos', 'Gramos', 'Litros', 'Mililitros', 'Unidades', 'Cajas', 'Sacos'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Nuevo Alimento',
            style: TextStyle(color: Color(0xFF7A1C20), fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: codigoCtrl,
                    decoration: const InputDecoration(labelText: 'Código Único (ej: AL-005)'),
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    controller: nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre del alimento'),
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: categoriaSeleccionada,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    items: categorias.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (val) => categoriaSeleccionada = val!,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: unidadSeleccionada,
                    decoration: const InputDecoration(labelText: 'Unidad de Medida'),
                    items: unidades.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (val) => unidadSeleccionada = val!,
                  ),
                  TextFormField(
                    controller: presentacionCtrl,
                    decoration: const InputDecoration(labelText: 'Presentación (ej: Bolsa 1kg)'),
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: 'Descripción / Observaciones'),
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
                    _alimentos.add(
                      AlimentoItem(
                        codigo: codigoCtrl.text.trim(),
                        nombre: nombreCtrl.text.trim(),
                        categoria: categoriaSeleccionada,
                        unidadMedida: unidadSeleccionada,
                        presentacion: presentacionCtrl.text.trim(),
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alimento registrado localmente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }


  
}



