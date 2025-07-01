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
    final currencyFormat = NumberFormat('#,###', 'es_CO');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Encabezado
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(logoImage, height: 50),
                  pw.SizedBox(height: 5),
                  pw.Text('FARMALÍDER', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text('NIT: 900123456-7', style: pw.TextStyle(fontSize: 10)),
                  pw.Text('Calle 26A #21D-58, Girón', style: pw.TextStyle(fontSize: 10)),
                  pw.Text('Tel: 320 329 7486', style: pw.TextStyle(fontSize: 10)),
                  pw.Text(formattedDate, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                ],
              ),
              pw.SizedBox(height: 8),

              // Info del cliente
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _textLine('Cliente', name),
                    _textLine('NIT / RFC', rfc),
                    _textLine('Correo', email),
                    _textLine('Dirección', address),
                    _textLine('Teléfono', phone),
                    _textLine('Pago', paymentMethod),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              pw.Text('Detalle de productos:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),

              // Tabla de productos
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _cell('Producto', bold: true),
                      _cell('Pres.', bold: true),
                      _cell('Cant.', bold: true),
                      _cell('P.Unit', bold: true),
                      _cell('Total', bold: true),
                    ],
                  ),
                  ...products.map((p) => pw.TableRow(
                    children: [
                      _cell(p.name),
                      _cell(p.presentation),
                      _cell('${p.units}'),
                      _cell('\$${currencyFormat.format(p.price)}'),
                      _cell('\$${currencyFormat.format(p.units * p.price)}'),
                    ],
                  )),
                ],
              ),

              pw.SizedBox(height: 6),
              pw.Divider(thickness: 1),

              // Total
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'TOTAL: \$${currencyFormat.format(total)}',
                  style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Center(
                child: pw.Text('Gracias por su compra', style: pw.TextStyle(fontSize: 9)),
              ),
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

pw.Widget _cell(String text, {bool bold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
    child: pw.Text(
      text,
      style: pw.TextStyle(fontSize: 9, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal),
    ),
  );
}

