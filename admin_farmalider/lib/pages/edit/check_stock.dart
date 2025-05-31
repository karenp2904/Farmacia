import 'package:admin_farmalider/SERVICES/edit_service.dart'; 
import 'package:flutter/material.dart';

class CheckStockWidget extends StatelessWidget {
  final int productId;
  final EditService productService = EditService();

  CheckStockWidget({required this.productId});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        productService.getProductStock(productId).then((stock) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Stock disponible: $stock'),
              backgroundColor: Colors.green, // Color verde para el SnackBar
            ),
          );
        }).catchError((error) {
          _showError(context, 'Error al verificar stock');
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Estilo verde para el botón
        foregroundColor: Colors.white, // Color del texto en el botón
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Relleno adicional
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Bordes redondeados
        ),
      ),
      child: Text('Verificar Stock'),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red, // Color rojo para el error
      ),
    );
  }
}
