import 'package:flutter/material.dart';

class CustomDropTextField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? selectedValue;
  final Function(String?)? onChanged;

  const CustomDropTextField({
    super.key,
    required this.label,
    required this.items,
    this.selectedValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            color: Colors.white,
            child: DropdownButtonFormField<String>(
              value: selectedValue,
              isExpanded: true,
              alignment: Alignment.centerRight,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              hint: Text(
                label,
                textDirection: TextDirection.rtl,
              ),
              items: items.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value, textDirection: TextDirection.rtl),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
