import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class ProfilePasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;

  const ProfilePasswordFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  State<ProfilePasswordFieldWidget> createState() =>
      _ProfilePasswordFieldWidgetState();
}

class _ProfilePasswordFieldWidgetState
    extends State<ProfilePasswordFieldWidget> {
  bool _obscure = true;

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
        controller: widget.controller,
        obscureText: _obscure,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey.shade500,
              size: 20,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ),
    );
  }
}
