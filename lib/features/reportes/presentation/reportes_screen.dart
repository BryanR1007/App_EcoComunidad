import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  Future<void> _generarComprobanteDonacion(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('EcoComunidad', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFF7A1C20))),
                      pw.Text('Sistema de Gestión de Ayuda Alimentaria', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Text('COMPROBANTE\nDE DONACIÓN', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFF7A1C20)), textAlign: pw.TextAlign.right),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColor.fromInt(0xFF7A1C20), thickness: 2),
              pw.SizedBox(height: 15),

              // Datos generales
              pw.Text('No. de Donación: DON-2026-001', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Fecha: 28/10/2026 10:30 AM'),
              pw.Text('Donante: Supermercado La Torre (Empresa)'),
              pw.Text('Responsable de Recepción: Encargado Almacén'),
              pw.SizedBox(height: 20),

              // Tabla de alimentos recibidos
              pw.Text('Alimentos Recibidos:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headers: ['Código', 'Alimento', 'Lote', 'Cantidad', 'Vencimiento'],
                data: <List<String>>[
                  ['AL-001', 'Arroz blanco', 'LOT-ARZ-501', '500 kg', '15/12/2026'],
                  ['AL-003', 'Aceite vegetal', 'LOT-ACE-102', '20 L', '02/11/2026'],
                ],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF7A1C20)),
                rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300))),
                cellPadding: const pw.EdgeInsets.all(8),
              ),
              
              pw.Spacer(),
             
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Container(width: 150, height: 1, color: PdfColors.black),
                      pw.SizedBox(height: 5),
                      pw.Text('Firma del Donante'),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Container(width: 150, height: 1, color: PdfColors.black),
                      pw.SizedBox(height: 5),
                      pw.Text('Sello y Firma EcoComunidad'),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Comprobante_Donacion_DON-2026-001.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprobantes y Reportes PDF'),
        backgroundColor: const Color(0xFF7A1C20),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Documentos y Comprobantes Oficiales',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF7A1C20)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Genera comprobantes oficiales en PDF listos para imprimir, guardar en el dispositivo o compartir digitalmente con donantes y beneficiarios.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF7A1C20),
                child: Icon(Icons.picture_as_pdf, color: Colors.white),
              ),
              title: const Text('Comprobante de Donación', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Generar PDF con detalle de lotes y alimentos recibidos.'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A1C20),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _generarComprobanteDonacion(context),
                child: const Text('Generar PDF'),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF1976D2),
                child: Icon(Icons.picture_as_pdf, color: Colors.white),
              ),
              title: const Text('Constancia de Entrega', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Generar PDF de entrega para familia beneficiaria.'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generando constancia de entrega en PDF...')),
                  );
                },
                child: const Text('Generar PDF'),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.assessment, color: Colors.white),
              ),
              title: const Text('Reporte de Inventario General', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Resumen actual de existencias por categoría y almacén.'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generando reporte general de existencias...')),
                  );
                },
                child: const Text('Ver Reporte'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}