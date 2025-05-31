import 'dart:convert';
import 'dart:io';

import 'package:admin_farmalider/SERVICES/edit_service.dart';
import 'package:admin_farmalider/model/product.dart';
import 'package:admin_farmalider/pages/edit/form/form.dart';
import 'package:flutter/material.dart';

class UpdateProductPage extends StatelessWidget {
  final Product product;

  const UpdateProductPage({super.key, required this.product});

  Future<bool> _updateProductSimple(Product product) async {
    final service = EditService();
    return await service.updateProduct(product.id!, product);
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(title: Text('Actualizar Producto')),
      body: ProductFormWidget(
        initialProduct: product,
        onSubmit: _updateProductSimple,
      ),
    );

  }
}
