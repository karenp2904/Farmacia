import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class WhatsappService {
  /// Envía la factura PDF al WhatsApp de un número específico,
  /// permitiendo configurar el código de país.
  static Future<void> shareInvoiceToWhatsapp({
    required String pdfFilePath,
    required String phoneNumber,
    required String countryCode, // Colombia por defecto
  }) async {
    final file = File(pdfFilePath);

    if (!await file.exists()) {
      throw Exception('El archivo PDF no existe.');
    }

    // Limpia el número de teléfono (elimina espacios, guiones, paréntesis)
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Crea número internacional completo
    final fullNumber = '$countryCode$cleanedNumber';

    // Comparte el PDF
    await Share.shareXFiles(
      [XFile(pdfFilePath)],
      text: 'Factura adjunta de Farmalíder 🧾',
    );

    // Abre el chat de WhatsApp
    final whatsappUrl = Uri.parse('https://wa.me/$fullNumber');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('No se pudo abrir el chat de WhatsApp.');
    }
  }
}
