import 'package:admin_farmalider/model/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditService {
  static final String baseUrl = 'http://192.168.20.71:3000/farmalider';

  // Agregar producto
  static Future<bool> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    print(response);
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error al agregar producto: ${response.body}');
    }
  }

  // Actualizar producto
  Future<bool> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response);
      throw Exception('Error al actualizar producto: ${response.body}');
    }
  }

  // Eliminar producto
  Future<bool> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/delete/$id'),
    );

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al eliminar producto: ${response.body}');
    }
  }

  // Verificar stock de producto
  Future<int> getProductStock(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id/stock'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['stock'] as int;
    } else {
      throw Exception('Error al verificar stock: ${response.body}');
    }
  }
}
