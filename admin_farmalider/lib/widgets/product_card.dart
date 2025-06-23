import 'package:flutter/material.dart';
import 'package:admin_farmalider/model/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final Function(String) onPresentationChange;

  const ProductCard({
    required this.product,
    required this.onTap,
    required this.onPresentationChange,
    super.key,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late String selectedPresentation;

  @override
  void initState() {
    super.initState();
    selectedPresentation = widget.product.presentation;
  }

  void onPresentationChange(String newPresentation) {
    setState(() {
      selectedPresentation = newPresentation;
    });
    widget.onPresentationChange(newPresentation);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.product.image ?? '';

    // Obtener el precio correspondiente a la presentación seleccionada
    final priceData = widget.product.presentation_prices.firstWhere(
      (item) => item['presentacion'] == selectedPresentation,
      orElse: () => {'precio': 0.0},
    );
    final price = (priceData['precio'] as num).toDouble();

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: const Color(0xFFE8F5E9), // Verde claro
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/default.png',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20), // Verde oscuro
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _infoChip("Marca", widget.product.brand, Colors.green.shade800),
                        _infoChip("Presentación", selectedPresentation, Colors.orange.shade700),
                        _infoChip("Activo", widget.product.activeIngredient, Colors.blue.shade700),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: widget.product.presentation_prices.any((item) => item['presentacion'] == selectedPresentation)
                          ? selectedPresentation
                          : widget.product.presentation_prices.isNotEmpty
                              ? widget.product.presentation_prices[0]['presentacion'] as String
                              : null,
                      onChanged: (String? newPresentation) {
                        if (newPresentation != null) {
                          onPresentationChange(newPresentation);
                        }
                      },
                      items: widget.product.presentation_prices.map<DropdownMenuItem<String>>((item) {
                        final presentacion = item['presentacion'] as String;
                        final precio = (item['precio'] as num).toDouble();
                        return DropdownMenuItem<String>(
                          value: presentacion,
                          child: Text('$presentacion - \$${precio.toStringAsFixed(2)}'),
                        );
                      }).toList(),
                    ),


                  ],
                ),
              ),             
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
