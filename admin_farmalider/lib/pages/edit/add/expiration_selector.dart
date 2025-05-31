import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpirationDateSelector extends StatelessWidget {
  final DateTime? expirationDate;
  final Function(DateTime) onDateSelected;

  const ExpirationDateSelector({
    super.key,
    required this.expirationDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Fecha de Vencimiento: ${expirationDate != null ? DateFormat('yyyy-MM-dd').format(expirationDate!) : 'No seleccionada'}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: expirationDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
          child: const Text('Seleccionar'),
        ),
      ],
    );
  }
}
