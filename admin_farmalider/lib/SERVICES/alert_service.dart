// services/alert_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product.dart';

class AlertService {
  final String baseUrl = 'http://192.168.20.71:3000/farmalider';

  Future<List<Product>> getExpired() async {
    final response = await http.get(Uri.parse('$baseUrl/products/expired'));
    return parseProducts(response.body);
  }

  Future<List<Product>> getExpiringMonth() async {
    final response = await http.get(Uri.parse('$baseUrl/products/expiringMonth'));
    return parseProducts(response.body);
  }

  Future<List<Product>> getExpiringYear() async {
    final response = await http.get(Uri.parse('$baseUrl/products/alerts'));
    return parseProducts(response.body);
  }

  List<Product> parseProducts(String body) {
    final decoded = json.decode(body);

    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      final List<dynamic> jsonData = decoded['data'];
      return jsonData.map((e) => Product.fromJson(e)).toList();
    }

    // Si el JSON ya es una lista directamente
    if (decoded is List) {
      return decoded.map((e) => Product.fromJson(e)).toList();
    }

    return [];
  }



}
