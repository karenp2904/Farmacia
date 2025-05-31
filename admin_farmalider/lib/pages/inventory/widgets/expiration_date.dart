import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpirationDateWidget extends StatelessWidget {
  final DateTime? expirationDate;

  const ExpirationDateWidget({this.expirationDate, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (expirationDate == null) return const SizedBox();

    final now = DateTime.now();
    final isExpired = expirationDate!.isBefore(DateTime(now.year, now.month, now.day));
    final formattedDate = DateFormat('dd/MM/yyyy').format(expirationDate!);

    final Color bgColor = isExpired ? Colors.red.shade100 : Colors.green.shade100;
    final Color borderColor = isExpired ? Colors.red.shade400 : Colors.green.shade400;
    final Color textColor = isExpired ? Colors.red.shade700 : Colors.green.shade700;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          isExpired
              ? '¡Producto vencido! ($formattedDate)'
              : 'Fecha de expiración: $formattedDate',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
