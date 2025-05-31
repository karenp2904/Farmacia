import 'package:flutter/material.dart';

class ActiveIngredientWidget extends StatelessWidget {
  final String activeIngredient;

  const ActiveIngredientWidget({required this.activeIngredient, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Text(
          'Ingrediente activo: $activeIngredient',
          style: TextStyle(
            fontSize: 14,
            color: Colors.orange.shade800,
          ),
        ),
      ),
    );
  }
}
