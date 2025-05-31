import 'package:url_launcher/url_launcher.dart';

class LauncherService {
  LauncherService._(); // Constructor privado para que no se instancie

  static Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se puede abrir el enlace: $url';
    }
  }
}
