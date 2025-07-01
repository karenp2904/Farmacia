import 'dart:convert';
import 'package:admin_farmalider/model/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = 'http://192.168.20.71:3000/farmalider'; // Cambiar

  Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    print(response);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print(data);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  String getImageUrl(String? imageName) {
    const baseUrl = 'http://192.168.20.71:3000';
    if (imageName == null || imageName.isEmpty) {
      return '$baseUrl/products/image?filename=default.png';
    }
    return '$baseUrl/products/image?filename=$imageName';
  }


  
  Future<List<Product>> searchProductsByName(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/search?query=$query'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        // Si no hay productos, retornar lista vacía
        if (data.isEmpty) return [];

        return data.map((e) => Product.fromJson(e)).toList();
      } else {
        throw Exception('Error al buscar productos: ${response.statusCode}');
      }
    } catch (error) {
      // Puedes optar por loguear el error, pero no lanzar la excepción
      print('Error en la búsqueda: $error');
      return []; // Retornar lista vacía para evitar errores en la UI
    }
  }



  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/category/$category'),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener productos por categoría');
    }
  }

  Future<List<Product>> searchProducts({
    String? query,
    String? category,
  }) async {
    if (category != null && category.isNotEmpty) {
      return getProductsByCategory(category);
    } else if (query != null && query.isNotEmpty) {
      return searchProductsByName(query);
    } else {
      return fetchAllProducts();
    }
  }
}
