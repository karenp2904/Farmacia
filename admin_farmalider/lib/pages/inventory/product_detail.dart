import 'package:admin_farmalider/pages/inventory/widgets/active_ingredient.dart';
import 'package:admin_farmalider/pages/inventory/widgets/brand_widget.dart';
import 'package:admin_farmalider/pages/inventory/widgets/category.dart';
import 'package:admin_farmalider/pages/inventory/widgets/expiration_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_farmalider/model/product.dart';
import 'package:admin_farmalider/model/productToPay.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final Function(ProductToPay) onAddToCart;

  const ProductDetailPage({
    required this.product,
    required this.onAddToCart,
    Key? key,
  }) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedPresentation = 'Unidad';

  @override
  void initState() {
    super.initState();
    if (widget.product.presentation_prices.isNotEmpty) {
      selectedPresentation =
          widget.product.presentation_prices[0]['presentacion'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name, style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green.shade700,
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProductImage(),
            const SizedBox(height: 20),
            _buildProductName(),
            const SizedBox(height: 10),
            BrandWidget(brand: widget.product.brand),
            const SizedBox(height: 20),

            CategoryWidget(category: widget.product.category),
            const SizedBox(height: 10),
            ExpirationDateWidget(expirationDate: widget.product.expirationDate),
            const SizedBox(height: 15),
            ActiveIngredientWidget(
              activeIngredient: widget.product.activeIngredient,
            ),
            
            const SizedBox(height: 20),
            _buildPriceListSection(),
            const SizedBox(height: 20),
            _buildDescriptionSection(),
            const SizedBox(height: 30),
            _buildAddToCartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Center(
      child: Image.asset(
        widget.product.image != null
            ? 'assets/images/${widget.product.image}'
            : 'assets/images/${widget.product.name.toLowerCase().replaceAll(' ', '_')}.png',
        height: 200,
        width: 200,
        fit: BoxFit.contain,
        errorBuilder:
            (_, __, ___) => const Icon(
              Icons.image_not_supported,
              size: 200,
              color: Colors.grey,
            ),
      ),
    );
  }

  Widget _buildProductName() {
    return Center(
      child: Text(
        widget.product.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade800,
        ),
      ),
    );
  }

  Widget _buildPriceListSection() {
    List<String> presentations =
        widget.product.presentation_prices
            .map<String>((item) => item['presentacion'] as String)
            .toList();

    if (!presentations.contains(selectedPresentation) &&
        presentations.isNotEmpty) {
      selectedPresentation = presentations.first;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200,
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Precios por Presentación:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: selectedPresentation,
            isExpanded: true,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedPresentation = newValue;
                });
              }
            },
            items:
                presentations.map<DropdownMenuItem<String>>((String value) {
                  double price = _getPriceForPresentation(value);
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('$value - \$${price.toStringAsFixed(2)}'),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  double _getPriceForPresentation(String presentation) {
    final priceData = widget.product.presentation_prices.firstWhere(
      (element) => element['presentacion'] == presentation,
      orElse: () => {'precio': 0.0, 'presentacion': presentation},
    );
    return priceData['precio'] ?? 0.0;
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200,
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descripción:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            widget.product.description,
            style: TextStyle(fontSize: 16, color: Colors.green.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700,
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(fontSize: 18),
      ),
      onPressed: () {
        double price = _getPriceForPresentation(selectedPresentation);
        ProductToPay productToPay = ProductToPay(
          id: widget.product.id,
          name: widget.product.name,
          units: 1,
          presentation: selectedPresentation,
          price: price,
        );
        print(productToPay);
        widget.onAddToCart(productToPay);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.product.name} añadido al carrito')),
        );

        Navigator.pop(context);
      },
      child: const Text(
        'Añadir al carrito',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
