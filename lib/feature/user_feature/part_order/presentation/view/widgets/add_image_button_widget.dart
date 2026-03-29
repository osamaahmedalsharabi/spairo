import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class AddImageButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final File? selectedImage;

  const AddImageButtonWidget({
    super.key,
    required this.onTap,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 1.3),
        ),
        child: selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.primary,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "إرفاق صورة",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
