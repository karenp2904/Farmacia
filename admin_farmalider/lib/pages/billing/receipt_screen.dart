import 'package:admin_farmalider/pages/billing/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:admin_farmalider/model/productToPay.dart';

class ReceiptScreen extends StatelessWidget {
  final String clientName;
  final String paymentMethod;
  final double total;
  final String invoiceFilePath;
  final List<ProductToPay> products;

  const ReceiptScreen({
    required this.clientName,
    required this.paymentMethod,
    required this.total,
    required this.invoiceFilePath,
    required this.products,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc().subtract(const Duration(hours: 5));

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: const Text("Factura Generada",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(Icons.check_circle_rounded, size: 80, color: Colors.green.shade600),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  "¡Factura Exitosa!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
              const Divider(height: 32),
              _infoRow("🧍 Cliente:", clientName),
              _infoRow("💳 Pago:", paymentMethod),
              _infoRow("🕒 Fecha:", "${now.day}/${now.month}/${now.year} - ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}"),
              const SizedBox(height: 20),

              Text("🛍️ Productos", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: products.map((p) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(flex: 4, child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                          Expanded(flex: 2, child: Text(p.presentation, textAlign: TextAlign.center)),
                          Expanded(flex: 1, child: Text('${p.units}', textAlign: TextAlign.center)),
                          Expanded(flex: 2, child: Text('\$${(p.units * p.price).toStringAsFixed(2)}', textAlign: TextAlign.right)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total a pagar:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Text("\$${total.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                ],
              ),

              const Spacer(),
              const Divider(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () async {
                      await Share.shareXFiles([XFile(invoiceFilePath)], text: 'Aquí tienes tu factura.');
                    },
                    icon: const Icon(Icons.share,color: Colors.white,),
                    label: const Text("Compartir", style: TextStyle(color: Colors.white),),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () =>  Navigator.push(
                                                context,
                                                MaterialPageRoute(  builder: (_) => CartPage())),
                    icon: const Icon(Icons.done, color: Colors.white,),
                    label: const Text("Finalizar",style: TextStyle(color: Colors.white),),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
