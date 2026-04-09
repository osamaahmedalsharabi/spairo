import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileInfoFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool editable;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;

  const ProfileInfoFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
    this.editable = true,
    this.keyboardType,
    this.formatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        readOnly: !editable,
        textDirection: TextDirection.rtl,
        keyboardType: keyboardType,
        inputFormatters: formatters,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: Icon(Icons.edit_note),
        ),
      ),
    );
  }
}
