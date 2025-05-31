import 'package:flutter/material.dart';

class PresentationSelector extends StatelessWidget {
  final void Function(String?) onChanged;
  final String selectedPresentation;

  const PresentationSelector({
    super.key,
    required this.onChanged,
    required this.selectedPresentation,
  });

  static final List<String> presentations = [
    'Tabletas',
    'Ampolla',
    'Frasco',
    'Crema',
    'Gotas',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedPresentation.isEmpty ? null : selectedPresentation,
      decoration: const InputDecoration(
        labelText: 'Presentación',
        border: OutlineInputBorder(),
      ),
      items: presentations.map((presentation) {
        return DropdownMenuItem(
          value: presentation,
          child: Text(presentation),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
