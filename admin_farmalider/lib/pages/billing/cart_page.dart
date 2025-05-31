import 'package:admin_farmalider/model/productToPay.dart';
import 'package:flutter/material.dart';
import 'package:admin_farmalider/SERVICES/billing_service.dart';
import 'package:admin_farmalider/pages/billing/InvoiceDataWidget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<ProductToPay> cart= [];

  @override
  void initState() {
    super.initState();
    cart = BillingService.instance.getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de compras',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green.shade700,
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text('El carrito está vacío', style: TextStyle(fontSize: 18)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final product = cart[index];
                      final subtotal = product.units * product.price;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Presentación: ${product.presentation}'),
                                  Text('\$${product.price.toStringAsFixed(2)} c/u'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            if (product.units > 1) {
                                              product.units--;
                                            }
                                          });
                                        },
                                      ),
                                      Text('${product.units}', style: const TextStyle(fontSize: 16)),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle, color: Colors.green),
                                        onPressed: () {
                                          setState(() {
                                            product.units++;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Total: \$${_calculateTotal().toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _clearCart,
                            icon: const Icon(Icons.delete, color: Colors.white,),
                            label: const Text('Vaciar carrito',style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          ),
                          ElevatedButton.icon(
                            onPressed: _checkout,
                            icon: const Icon(Icons.payment, color: Colors.white,),
                            label: const Text('Finalizar compra',style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  double _calculateTotal() {
    return cart.fold(0, (sum, product) => sum + (product.units * product.price));
  }

  void _clearCart() {
    BillingService.instance.clearCart();
    setState(() {
      cart = [];
    });
  }

  void _checkout() {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El carrito está vacío.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => InvoiceScreen(),
    );
  }
}
