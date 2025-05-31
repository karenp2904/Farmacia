import 'package:admin_farmalider/SERVICES/flutter/category_service.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String?) onChanged;

  const CategorySelector({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Obtenemos la lista de categorías desde el CategoryService
    final categories = CategoryService.getCategories();

    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: const InputDecoration(
        labelText: 'Categoría',
        border: OutlineInputBorder(),
      ),
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
