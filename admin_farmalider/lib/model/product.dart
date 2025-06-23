import 'package:intl/intl.dart';

class Product {
  final int id;
  String name;
  final String category;
  final String presentation;
  int units;
  final  List<Map<String, dynamic>>  presentation_prices;  // Lista de precios con etiquetas
  DateTime? expirationDate;
  final String brand;
  final String activeIngredient;
  final String description;
  String? image; // Aquí la base64

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.presentation,
    required this.units,
    required this.presentation_prices,  // Recibe la lista de precios con sus descripciones
    this.expirationDate,
    required this.brand,
    required this.activeIngredient,
    required this.description,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    DateTime? expirationDate;
    if (json['expiration_date'] != null) {
      expirationDate = DateTime.tryParse(json['expiration_date']?.toString().split(' ')[0] ?? '');
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      presentation: json['presentation'] ?? '',
      units: json['units'] ?? 0,
      presentation_prices: List<Map<String, dynamic>>.from(
        (json['price'] ?? []).map((item) => {
          'presentacion': item['presentacion'],
          'precio': (item['precio'] as num),
        }),
      ),
      expirationDate: expirationDate,
      brand: json['brand'] ?? '',
      activeIngredient: json['active_ingredient'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',  // nullable
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'presentation': presentation,
    'units': units,
    'presentation_prices': presentation_prices, // Asegúrate de que esta lista esté bien estructurada
    'expirationDate': expirationDate,
    'brand': brand,
    'activeIngredient': activeIngredient,
    'description': description,
    'image': image,
  };


  String? get formattedExpirationDate {
    if (expirationDate != null) {
      return DateFormat('dd/MM/yyyy').format(expirationDate!);
    }
    return null;
  }
}
