import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class ProfileLocationSectionWidget extends StatelessWidget {
  final String? currentLocation;
  final VoidCallback onTapPickLocation;

  const ProfileLocationSectionWidget({
    super.key,
    required this.currentLocation,
    required this.onTapPickLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الموقع',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTapPickLocation,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    currentLocation ?? 'اضغط لتحديد موقعك',
                    style: TextStyle(
                      fontSize: 14,
                      color: currentLocation != null
                          ? Colors.black87
                          : Colors.grey,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
