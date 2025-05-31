import 'dart:convert';
import 'dart:io';
import 'package:admin_farmalider/pages/edit/add/add_text.dart';
import 'package:admin_farmalider/pages/edit/add/selector_category.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin_farmalider/SERVICES/edit_service.dart';
import 'package:admin_farmalider/model/product.dart';
import 'package:admin_farmalider/pages/edit/add/presentation_selector.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _unitsController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _sachetPriceController = TextEditingController();
  final _brandController = TextEditingController();
  final _activeIngredientController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _expirationDate;
  File? _image;
  final picker = ImagePicker();
  String _selectedPresentation = '';
  int _stock = 0;
  final _boxPriceController = TextEditingController();
  final _packetPriceController = TextEditingController();
  final _pillPriceController = TextEditingController();

  List<Map<String, dynamic>> precios = [];

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submit() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una imagen')),
      );
      return;
    }

    final bytes = await _image!.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Crear una lista de precios dependiendo de la presentación seleccionada
    if (_selectedPresentation == 'Tabletas') {
      precios = [
        {
          'precio': double.tryParse(_boxPriceController.text) ?? 0.0,
          'presentacion': 'Caja',
        },
        {
          'precio': double.tryParse(_packetPriceController.text) ?? 0.0,
          'presentacion': 'Sobre',
        },
        {
          'precio': double.tryParse(_pillPriceController.text) ?? 0.0,
          'presentacion': 'Pastilla',
        },
      ];
    } else {
      precios = [
        {
          'precio': double.tryParse(_unitPriceController.text) ?? 0.0,
          'presentacion': 'Unidad',
        },
      ];
    }

    final product = Product(
      id: 0, // El servidor generará el ID
      name: _nameController.text,
      category: _categoryController.text,
      presentation: _selectedPresentation,
      units: int.tryParse(_unitsController.text) ?? 0,
      presentation_prices: precios,  // Asignar la lista de precios con descripciones
      expirationDate: _expirationDate,
      brand: _brandController.text,
      activeIngredient: _activeIngredientController.text,
      description: _descriptionController.text,
      image: base64Image,
    );

    await EditService.addProduct(product);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto añadido exitosamente')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Producto',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green.shade700,
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddProductTextField(
              controller: _nameController,
              label: 'Nombre',
            ),
            const SizedBox(height: 16),
            CategorySelector(
              controller: _categoryController, 
              onChanged: (String? value) {
                setState(() {
                  // Actualiza el controlador con el valor seleccionado
                  _categoryController.text = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            PresentationSelector(
              onChanged: (value) {
                setState(() {
                  _selectedPresentation = value ?? '';
                });
              },
              selectedPresentation: _selectedPresentation,
            ),
            const SizedBox(height: 16),
            if (_selectedPresentation == 'Tabletas') ...[
              AddProductTextField(
                controller: _boxPriceController,
                label: 'Precio por Caja',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              AddProductTextField(
                controller: _sachetPriceController,
                label: 'Precio por Sobre',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              AddProductTextField(
                controller: _unitsController,
                label: 'Unidades (Total Caja)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ] else ...[
              AddProductTextField(
                controller: _unitsController,
                label: 'Unidades',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],
            AddProductTextField(
              controller: _unitPriceController,
              label: 'Precio Unitario',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: _pickImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image),
                    SizedBox(width: 8), // Espacio entre el icono y el texto
                    Text('Seleccionar Imagen'),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            if (_image != null)
              Image.file(
                _image!,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green.shade700,
              ),
              child: Text('Añadir Producto', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _unitPriceController.dispose();
    _boxPriceController.dispose();
    _sachetPriceController.dispose();
    _unitsController.dispose();
    _brandController.dispose();
    _activeIngredientController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
