import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class AdminManageSection extends StatelessWidget {
  final VoidCallback onBrandsTap;
  final VoidCallback onCategoriesTap;

  const AdminManageSection({
    super.key,
    required this.onBrandsTap,
    required this.onCategoriesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: _ManageButton(
          icon: Icons.directions_car,
          label: 'إدارة البراندات',
          color: Colors.blue,
          onTap: onBrandsTap,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _ManageButton(
          icon: Icons.category,
          label: 'إدارة الأصناف',
          color: AppColors.primary,
          onTap: onCategoriesTap,
        ),
      ),
    ]);
  }
}

class _ManageButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ManageButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: color.withValues(alpha: 0.2)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              )),
        ]),
      ),
    );
  }
}
