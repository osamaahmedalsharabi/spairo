import 'package:flutter/material.dart';
import '../../../../../../Core/Theme/app_colors.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAllPressed;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: onViewAllPressed,
            child: const Text(
              'عرض الكل',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
