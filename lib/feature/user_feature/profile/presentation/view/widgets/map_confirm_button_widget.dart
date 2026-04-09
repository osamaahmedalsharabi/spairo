import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class MapConfirmButtonWidget extends StatelessWidget {
  final String address;
  final VoidCallback onConfirm;
  const MapConfirmButtonWidget({
    super.key, required this.address, required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      if (address.isNotEmpty) Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.08), blurRadius: 8)],
        ),
        child: Row(children: [
          Icon(Icons.location_on, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(address, style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 15)),
        ]),
      ),
      SizedBox(
        width: double.infinity, height: 50,
        child: ElevatedButton(
          onPressed: address.isEmpty ? null : onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('تأكيد الموقع',
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    ]);
  }
}
