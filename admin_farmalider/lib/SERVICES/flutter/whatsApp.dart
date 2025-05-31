import 'package:admin_farmalider/SERVICES/flutter/launcher_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class WhatsappService {
   static Future<void> sendInvoice(String phoneNumber, String pdfFilePath) async {
    final file = File(pdfFilePath);

    // Verificar si el archivo existe
    if (await file.exists()) {
      final url = Uri.parse(
        'https://wa.me/$phoneNumber?text=Factura%20Adjunta%20-%20${Uri.encodeComponent('Factura de compra')}',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        await LauncherService.openUrl(url.toString());
      } else {
        throw Exception('No se pudo abrir WhatsApp.');
      }
    } else {
      throw Exception('El archivo PDF no existe.');
    }
  }
}
