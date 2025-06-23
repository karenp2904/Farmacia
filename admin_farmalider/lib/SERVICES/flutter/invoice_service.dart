import 'dart:io';
import 'package:admin_farmalider/model/productToPay.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class InvoiceService {
  static Future<String> generateInvoicePdf({
    required String name,
    required String rfc,
    required String email,
    required String address,
    required String phone,
    required String paymentMethod,
    required double total,
    required List<ProductToPay> products,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);

    final logoBytes = await rootBundle.load('assets/images/logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Image(logoImage, height: 45)),
              pw.SizedBox(height: 5),
              pw.Center(child: pw.Text('FARMALÍDER', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Center(child: pw.Text('NIT: 900123456-7')),
              pw.Center(child: pw.Text('Calle 26A #21D-58, Girón')),
              pw.Center(child: pw.Text('Tel: 320 329 7486')),
              pw.Center(child: pw.Text(formattedDate, style: pw.TextStyle(fontSize: 9))),
              pw.SizedBox(height: 10),

              pw.Divider(thickness: 1),
              pw.Center(child: pw.Text('FACTURA', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))),
              pw.Divider(thickness: 1),

              _textLine('Cliente', name),
              _textLine('NIT / RFC', rfc),
              _textLine('Correo', email),
              _textLine('Dirección', address),
              _textLine('Teléfono', phone),
              _textLine('Pago', paymentMethod),
              pw.SizedBox(height: 8),

              pw.Text('Detalle de productos:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),

              pw.Table.fromTextArray(
                headers: ['Producto', 'Pres.', 'Cant.', 'P.Unit', 'Total'],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
                cellStyle: pw.TextStyle(fontSize: 8),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                data: products.map((p) => [
                  p.name,
                  p.presentation,
                  p.units.toString(),
                  '\$${p.price.toStringAsFixed(2)}',
                  '\$${(p.units * p.price).toStringAsFixed(2)}',
                ]).toList(),
                columnWidths: {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(1.2),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1.5),
                  4: pw.FlexColumnWidth(1.5),
                },
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.centerRight,
                },
              ),

              pw.Divider(thickness: 1),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'TOTAL: \$${total.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Center(child: pw.Text('Gracias por su compra', style: pw.TextStyle(fontSize: 9))),
              pw.Center(child: pw.Text('www.farmalider.com', style: pw.TextStyle(fontSize: 9))),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/factura_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static pw.Widget _textLine(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Text('$label: $value', style: pw.TextStyle(fontSize: 9)),
    );
  }
}
