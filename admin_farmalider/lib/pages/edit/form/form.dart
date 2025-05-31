import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:admin_farmalider/model/product.dart';

typedef OnSubmitProduct = Future<bool> Function(Product product);

class ProductFormWidget extends StatefulWidget {
  final Product? initialProduct;
  final OnSubmitProduct onSubmit;

  const ProductFormWidget({super.key, this.initialProduct, required this.onSubmit});

  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  late final TextEditingController nameController;
  late final TextEditingController stockController;
  late final TextEditingController categoryController;
  late final TextEditingController brandController;
  late final TextEditingController ingredientController;
  late final TextEditingController descriptionController;

  // Precio para las presentaciones
  late final TextEditingController priceBoxController;
  late final TextEditingController pricePacketController;
  late final TextEditingController pricePillController;
  late final TextEditingController pricePerTabletController;

  late final TextEditingController presentationController;

  DateTime? expirationDate;
  File? imageFile;

  @override
  void initState() {
    super.initState();

    final product = widget.initialProduct;

    nameController = TextEditingController(text: product?.name ?? '');
    stockController = TextEditingController(text: product?.units.toString() ?? '');
    categoryController = TextEditingController(text: product?.category ?? '');
    brandController = TextEditingController(text: product?.brand ?? '');
    ingredientController = TextEditingController(text: product?.activeIngredient ?? '');
    descriptionController = TextEditingController(text: product?.description ?? '');

    presentationController = TextEditingController(text: product?.presentation ?? '');

    // Precios iniciales
    priceBoxController = TextEditingController(text: _getPrice(product, 'Caja'));
    pricePacketController = TextEditingController(text: _getPrice(product, 'Sobre'));
    pricePillController = TextEditingController(text: _getPrice(product, 'Pastilla'));
    pricePerTabletController = TextEditingController(text: _getPrice(product, 'Unidad'));

    expirationDate = product?.expirationDate;
  }

  String _getPrice(Product? product, String presentation) {
    if (product == null) return '';
    final found = product.presentation_prices.firstWhere(
      (p) => p['presentacion'] == presentation,
      orElse: () => {'precio': ''},
    );
    return found['precio'].toString();
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty) return false;
    if (int.tryParse(stockController.text) == null) return false;

    bool validPrices = false;
    if (presentationController.text == 'Tabletas') {
      validPrices = _validPrice(priceBoxController.text) &&
          _validPrice(pricePacketController.text) &&
          _validPrice(pricePillController.text);
    } else {
      validPrices = _validPrice(pricePerTabletController.text);
    }
    return validPrices;
  }

  bool _validPrice(String text) {
    final value = double.tryParse(text);
    return value != null && value > 0;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: expirationDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      setState(() {
        expirationDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => imageFile = File(image.path));
  }

  Future<void> _submit() async {
    if (!_validateInputs()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complete los campos obligatorios y valide los precios')));
      return;
    }

    List<Map<String, dynamic>> prices;
    if (presentationController.text == 'Tabletas') {
      prices = [
        {'presentacion': 'Caja', 'precio': double.parse(priceBoxController.text)},
        {'presentacion': 'Sobre', 'precio': double.parse(pricePacketController.text)},
        {'presentacion': 'Pastilla', 'precio': double.parse(pricePillController.text)},
      ];
    } else {
      prices = [
        {'presentacion': 'Unidad', 'precio': double.parse(pricePerTabletController.text)},
      ];
    }

    final product = Product(
      id: widget.initialProduct?.id ?? 0, // En creación podrías generar id distinto
      name: nameController.text,
      units: int.parse(stockController.text),
      category: categoryController.text,
      presentation: presentationController.text,
      brand: brandController.text,
      activeIngredient: ingredientController.text,
      description: descriptionController.text,
      expirationDate: expirationDate,
      presentation_prices: prices,
    );

    // Aquí añadimos la imagen en base64 si existe
    if (imageFile != null) {
      final bytes = await imageFile!.readAsBytes();
      product.image = base64Encode(bytes);
    }

    final success = await widget.onSubmit(product);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.initialProduct == null ? 'Producto creado con éxito' : 'Producto actualizado con éxito')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al guardar el producto')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTextField(nameController, 'Nombre del Producto'),
          _buildPresentationDropdown(),
          if (presentationController.text == 'Tabletas') ...[
            _buildTextField(priceBoxController, 'Precio Caja', TextInputType.number),
            _buildTextField(pricePacketController, 'Precio Sobre', TextInputType.number),
            _buildTextField(pricePillController, 'Precio Pastilla', TextInputType.number),
          ] else
            _buildTextField(pricePerTabletController, 'Precio Unidad', TextInputType.number),
          _buildTextField(stockController, 'Stock', TextInputType.number),
          _buildTextField(categoryController, 'Categoría'),
          _buildTextField(brandController, 'Marca'),
          _buildTextField(ingredientController, 'Ingrediente Activo'),
          _buildTextField(descriptionController, 'Descripción'),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                expirationDate == null
                    ? 'Sin fecha de vencimiento'
                    : 'Vence: ${DateFormat('dd/MM/yyyy').format(expirationDate!)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _pickDate,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                child: const Text("Cambiar Fecha", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (imageFile != null)
            Image.file(imageFile!, height: 100)
          else if (widget.initialProduct?.image != null && widget.initialProduct!.image!.isNotEmpty)
            Image.memory(
              base64Decode(widget.initialProduct!.image!),
              height: 100,
              fit: BoxFit.cover,
            )
          else
            const Text("No se ha seleccionado imagen"),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text("Seleccionar Imagen", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, iconColor: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              backgroundColor: Colors.green.shade700,
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: Text(widget.initialProduct == null ? 'Crear Producto' : 'Guardar Cambios', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green.shade700), borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static final List<String> presentations = [
    'Tabletas',
    'Ampolla',
    'Frasco',
    'Crema',
    'Gotas',
  ];

  Widget _buildPresentationDropdown() {
    // Si el valor actual no está en presentations, ponlo null para evitar error
    final currentValue = presentations.contains(presentationController.text)
        ? presentationController.text
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        items: presentations.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) {
          if (val != null) setState(() => presentationController.text = val);
        },
        decoration: InputDecoration(
          labelText: 'Presentación',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green.shade700), borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

}
