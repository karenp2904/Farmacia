import 'package:admin_farmalider/SERVICES/billing_service.dart';
import 'package:admin_farmalider/SERVICES/flutter/invoice_service.dart';
import 'package:admin_farmalider/SERVICES/flutter/whatsApp.dart';
import 'package:admin_farmalider/pages/billing/receipt_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String rfc = '';
  String email = '';
  String address = '';
  String phone = '';
  String paymentMethod = 'Efectivo';
  bool isProcessing = false;
  final currencyFormat = NumberFormat('#,###', 'es_CO');

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isProcessing = true);

    final cart = BillingService.instance.getCart();
    final total = BillingService.instance.getTotal();

    try {
      final pdfFilePath = await InvoiceService.generateInvoicePdf(
        name: name,
        rfc: rfc,
        email: email,
        address: address,
        phone: phone,
        paymentMethod: paymentMethod,
        total: total,
        products: cart
      );
       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiptScreen(
            clientName: name,
            paymentMethod: paymentMethod,
            total: total,
            invoiceFilePath: pdfFilePath,
            products: cart,
          ),
        ),
      );

      await WhatsappService.shareInvoiceToWhatsapp(
        pdfFilePath: pdfFilePath,
        phoneNumber: phone,
        countryCode: '57', // por defecto es Colombia, pero puedes poner '52' (México), etc.
      );
      /*
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Factura generada y enviada por WhatsApp.')),
      );
      */
   

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar o enviar la factura: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: const Text(
          'Datos de Facturación',
          
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
         
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Datos para la Facturación',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Completa los campos para generar tu factura electrónica.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    // Campo Nombre
                    _buildTextField(
                      label: 'Nombre Completo',
                      icon: Icons.person,
                      validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 16),

                    // RFC/NIT
                    _buildTextField(
                      label: 'Documento/NIT',
                      icon: Icons.badge,
                      validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                      onChanged: (value) => rfc = value,
                    ),
                    const SizedBox(height: 16),

                    // Correo
                    _buildTextField(
                      label: 'Correo Electrónico',
                      icon: Icons.email,
                      validator: (value) => !RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value!)
                          ? 'Correo inválido'
                          : null,
                      onChanged: (value) => email = value,
                    ),
                    const SizedBox(height: 16),

                    // Dirección
                    _buildTextField(
                      label: 'Dirección',
                      icon: Icons.home,
                      validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                      onChanged: (value) => address = value,
                    ),
                    const SizedBox(height: 16),

                    // Teléfono
                    _buildTextField(
                      label: 'Teléfono',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.length < 10 ? 'Número inválido' : null,
                      onChanged: (value) => phone = value,
                    ),
                    const SizedBox(height: 16),

                    // Método de Pago
                    _buildDropdown(
                      label: 'Método de Pago',
                      value: paymentMethod,
                      items: ['Efectivo', 'Tarjeta de Crédito', 'Transferencia'],
                      onChanged: (value) => setState(() => paymentMethod = value!),
                    ),
                    const SizedBox(height: 24),

                    // Botón
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.receipt_long, color: Colors.white,),
                        onPressed: isProcessing ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        
                        label: isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Generar Factura',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldValidator<String> validator,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
    );
  }


  // Widget para Dropdown
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: items.map((method) {
        return DropdownMenuItem<String>(
          value: method,
          child: Text(method),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
