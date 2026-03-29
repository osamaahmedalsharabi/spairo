import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class SubmitOrderButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const SubmitOrderButtonWidget({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "تأكيد الطلب",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
      ),
    );
  }
}
