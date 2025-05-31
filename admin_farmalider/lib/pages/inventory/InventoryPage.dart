import 'package:admin_farmalider/model/product.dart';
import 'package:admin_farmalider/SERVICES/billing_service.dart';
import 'package:admin_farmalider/SERVICES/flutter/category_service.dart';
import 'package:admin_farmalider/SERVICES/products_service.dart';
import 'package:admin_farmalider/model/productToPay.dart';
import 'package:admin_farmalider/widgets/category_bar.dart';
import 'package:admin_farmalider/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:admin_farmalider/pages/inventory/product_detail.dart';
import 'package:admin_farmalider/widgets/product_card.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late Future<List<Product>> _products;
  String _searchQuery = '';
  String? _selectedCategory;

  final List<String> _categories = CategoryService.getCategories();

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Solo una llamada
  }

  void _fetchProducts() {
    setState(() {
      if (_selectedCategory != null && _selectedCategory != 'Todas') {
        // Filtrar por categoría específica
        _products = ProductService().searchProducts(
          query: '',
          category: _selectedCategory,
        );
      } else if (_searchQuery.isNotEmpty) {
        // Si hay búsqueda activa
        _products = ProductService().searchProductsByName(_searchQuery);
      } else {
        // Caso base: traer todos
        _products = ProductService().fetchAllProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          ProductSearchBar(
            onChanged: (query) {
              // Cuando cambia la búsqueda, se limpia la categoría
              setState(() {
                _searchQuery = query;
                _selectedCategory = null;
              });
              _fetchProducts();
            },
          ),
          // Dropdown de categorías
          CategoryDropdown(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onChanged: (value) {
              // Cuando cambia la categoría, se limpia la búsqueda
              setState(() {
                _selectedCategory = value;
                _searchQuery =
                    ''; // Limpiamos la búsqueda cuando se elige una categoría
              });
              _fetchProducts();
            },
          ),
          const SizedBox(height: 8),
          // Cargando productos
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error al cargar los productos'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay productos disponibles'),
                  );
                }

                final products = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              product: product,
                              onAddToCart: (ProductToPay p) {
                                // Add the ProductToPay to the cart in the BillingService
                                BillingService.instance.addToCart(p);
                              },
                            ),
                          ),

                        );
                      },
                      onPresentationChange: (String) {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
