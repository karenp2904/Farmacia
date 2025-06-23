import 'dart:convert';
import 'dart:io';

import 'package:admin_farmalider/SERVICES/edit_service.dart';
import 'package:admin_farmalider/model/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class UpdateProductPage extends StatefulWidget {
  final Product product;

  const UpdateProductPage({super.key, required this.product});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  late Product editableProduct;
  final _dateController = TextEditingController();
  final EditService _editService = EditService();

  @override
  void initState() {
    super.initState();
    editableProduct = widget.product;
    if (editableProduct.expirationDate != null) {
      _dateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(editableProduct.expirationDate!);
    }
  }

  Future<void> _updateField(String field, dynamic value) async {
    print('[DEBUG] Intentando actualizar: $field = $value (${value.runtimeType})');
    final success = await _editService.updateField(
      editableProduct.id,
      field,
      value,
    );
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Campo "$field" actualizado.')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error actualizando $field')));
    }
  }


  Future<void> _pickImageAndUpload() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final base64Image = base64Encode(bytes);
      setState(() {
        editableProduct.image = base64Image;
      });
      await _updateField('image', base64Image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Producto')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection(
              title: 'Nombre',
              child: TextFormField(
                initialValue: editableProduct.name,
                onChanged: (value) => editableProduct.name = value,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              onSave: () => _updateField('name', editableProduct.name),
            ),
            _buildSection(
                  title: 'Unidades',
                  child: TextFormField(
                    initialValue: editableProduct.units.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null) {
                        editableProduct.units = parsed;
                      }
                    },
                    decoration: InputDecoration(labelText: 'Unidades'),
                  ),
                  onSave: () => _updateField('units', editableProduct.units),
                ),
            _buildSection(
              title: 'Fecha de Vencimiento',
              child: TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Selecciona la fecha'),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate:
                        editableProduct.expirationDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365 * 10)),
                  );
                  if (picked != null) {
                    setState(() {
                      editableProduct.expirationDate = picked;
                      _dateController.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(picked);
                    });
                    await _updateField('expirationDate', _dateController.text);
                  }
                },
              ),
              onSave:
                  () => _updateField('expirationDate', _dateController.text),
            ),
            _buildSection(
              title: 'Imagen (toca para cambiar)',
              child:
                  editableProduct.image != null &&
                          editableProduct.image!.isNotEmpty
                      ? GestureDetector(
                        onTap: _pickImageAndUpload,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            base64Decode(editableProduct.image!),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                      : ElevatedButton.icon(
                        onPressed: _pickImageAndUpload,
                        icon: Icon(Icons.image),
                        label: Text('Seleccionar Imagen'),
                      ),
              onSave: () {}, // se guarda automáticamente al seleccionar
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    required VoidCallback onSave,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                child,
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: onSave,
                  icon: Icon(Icons.save, color: Colors.white),
                  label: Text('Guardar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
