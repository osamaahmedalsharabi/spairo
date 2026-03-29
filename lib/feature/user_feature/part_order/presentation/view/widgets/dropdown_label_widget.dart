import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class DropdownLabelWidget extends StatelessWidget {
  final String label;

  const DropdownLabelWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
