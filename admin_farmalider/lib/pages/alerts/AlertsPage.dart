import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_farmalider/model/product.dart';
import 'package:admin_farmalider/services/products_service.dart';
import 'package:admin_farmalider/services/alert_service.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final AlertService alertService = AlertService();
  final ProductService productService = ProductService();

  late Future<List<List<Product>>> alertData;
  int selectedIndex = 0;

  final List<String> filters = [
    'Vencidos',       // 0
    'Este mes',       // 1
    'Próximo mes',    // 2 
    'Este año',       // 3
    'Bajo stock',     // 4 
  ];

  final List<Color> filterColors = [
    Colors.red.shade600,      // Vencidos
    Colors.orange.shade600,   // Este mes
    Colors.amber.shade700,    // Próximo mes
    Colors.blue.shade700,     // Este año
    Colors.purple.shade700,   // Bajo stock
  ];


  @override
  void initState() {
    super.initState();

      alertData = Future.wait([
      alertService.getExpired(),          // [0]
      alertService.getExpiringMonth(),   // [1]
      getExpiringNextMonth(),            // [2]
      alertService.getExpiringYear(),    // [3]
      productService.fetchAllProducts(),  // [4] → para low stock
    ]);

  }

  Future<List<Product>> getExpiringNextMonth() async {
    final now = DateTime.now();
    final firstDayNextMonth = DateTime(now.year, now.month + 1, 1);
    final lastDayNextMonth = DateTime(now.year, now.month + 2, 0);

    final products = await productService.fetchAllProducts();
    return products.where((product) {
      final date = product.expirationDate;
      return date != null &&
          date.isAfter(firstDayNextMonth.subtract(const Duration(days: 1))) &&
          date.isBefore(lastDayNextMonth.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: FutureBuilder<List<List<Product>>>(
        future: alertData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final expired = snapshot.data?[0] ?? [];
          final expiringMonth = snapshot.data?[1] ?? [];
          final expiringNextMonth = snapshot.data?[2] ?? [];
          final expiringYear = snapshot.data?[3] ?? [];
          final allProducts = snapshot.data?[4] ?? [];
          final lowStock = allProducts.where((p) => p.units <= 5).toList();

          List<Product> visibleProducts;
          switch (selectedIndex) {
            case 0:
              visibleProducts = expired;
              break;
            case 1:
              visibleProducts = expiringMonth;
              break;
            case 2:
              visibleProducts = expiringNextMonth;
              break;
            case 3:
              visibleProducts = expiringYear;
              break;
            case 4:
              visibleProducts = lowStock;
              break;
            default:
              visibleProducts = [];
          }


          return Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(filters.length, (i) {
                    final isSelected = selectedIndex == i;
                    final color = filterColors[i];
                    return ChoiceChip(
                      label: Text(filters[i]),
                      selected: isSelected,
                      selectedColor: color.withOpacity(0.25),
                      backgroundColor: Colors.grey.shade200,
                      labelStyle: TextStyle(
                        color: isSelected ? color : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(
                          color: isSelected ? color : Colors.grey.shade400,
                        ),
                      ),
                      onSelected: (_) => setState(() => selectedIndex = i),
                    );
                  }),
                ),

              ),
              const SizedBox(height: 12),
              Expanded(
                child: visibleProducts.isEmpty
                    ? Center(
                        child: Text(
                          'No hay productos para esta categoría',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: visibleProducts.length,
                        itemBuilder: (context, index) {
                          final product = visibleProducts[index];
                          final formattedDate = product.expirationDate != null
                              ? DateFormat('dd/MM/yyyy').format(product.expirationDate!)
                              : 'Sin fecha';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 17)),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 6,
                                  children: [
                                    _tag('Vence: $formattedDate',
                                        Colors.orange.shade100,
                                        textColor: Colors.orange.shade800),
                                    _tag('Stock: ${product.units}',
                                        product.units <= 10
                                            ? Colors.red.shade100
                                            : Colors.green.shade100,
                                        textColor: product.units <= 10
                                            ? Colors.red.shade700
                                            : Colors.green.shade700),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tag(String text, Color backgroundColor, {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
