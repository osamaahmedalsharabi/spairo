import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class PartCard extends StatelessWidget {
  final String name;
  final String image;
  final VoidCallback onTap;

  const PartCard({
    super.key,
    required this.name,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 12,
        color: AppColors.background,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Image.asset(image, height: 80),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
