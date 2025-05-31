import 'dart:convert';

import 'package:admin_farmalider/model/productToPay.dart';
import 'package:http/http.dart' as http;

class BillingService {
  // Instancia privada estática
  static final BillingService _instance = BillingService._internal();

  // Lista privada que representa el carrito de compras
  final List<ProductToPay> _cart = [];

  // Constructor privado para evitar instanciación externa
  BillingService._internal();

  // Getter para acceder a la instancia única
  static BillingService get instance => _instance;

  // Agregar producto al carrito
  void addToCart(ProductToPay product) {
    _cart.add(product);
  }

  // Eliminar producto del carrito
  void removeFromCart(ProductToPay product) {
    _cart.remove(product);
  }

  // Obtener los productos en el carrito (solo lectura)
  List<ProductToPay> getCart() => List.unmodifiable(_cart);

  // Obtener el total del carrito
  double getTotal() {
    return _cart.fold(0.0, (total, item) => total + item.price);
  }

  // Limpiar el carrito
  void clearCart() {
    _cart.clear();
  }

  // Generar factura
  String generateInvoice() {
    final buffer = StringBuffer();
    buffer.writeln('FACTURA');
    buffer.writeln('----------------------');
    for (var product in _cart) {
      buffer.writeln('${product.name} - \$${product.price}');
    }
    buffer.writeln('----------------------');
    buffer.writeln('TOTAL: \$${getTotal().toStringAsFixed(2)}');
    return buffer.toString();
  }
  Future<void> confirmInvoiceOnBackend({
    required Map<String, dynamic> client,
    required List<Map<String, dynamic>> products,
  }) async {
    final response = await http.post(
      Uri.parse('http://192.168.20.71:3000/farmalider/invoices'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'client': client,
        'products': products,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al guardar la factura en el servidor');
    }
  }

}
