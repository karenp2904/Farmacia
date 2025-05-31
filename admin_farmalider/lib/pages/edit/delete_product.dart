import 'package:flutter/material.dart';
import 'package:admin_farmalider/SERVICES/edit_service.dart';
import 'package:admin_farmalider/model/product.dart';

class DeleteProductWidget extends StatelessWidget {
  final Product product;

  const DeleteProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eliminar Producto',style: TextStyle(color: Colors.white),),
      content: Text('¿Estás seguro de eliminar "${product.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.delete),
          label: const Text('Eliminar'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            final success = await EditService().deleteProduct(product.id);
            Navigator.pop(context, success); // Devuelve si se eliminó con éxito
          },
        ),
      ],
    );
  }
}
