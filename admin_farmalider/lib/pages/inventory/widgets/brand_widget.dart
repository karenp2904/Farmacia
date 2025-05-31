import 'package:flutter/material.dart';

class BrandWidget extends StatelessWidget {
  final String brand;

  const BrandWidget({required this.brand, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.label_important, color: Colors.green),
        const SizedBox(width: 8),
        Text(
          'Marca: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.green.shade800,
          ),
        ),
        Expanded(
          child: Text(
            brand,
            style: TextStyle(
              fontSize: 16,
              color: Colors.green.shade600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
