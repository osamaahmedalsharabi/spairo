import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class DrawerListTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DrawerListTileWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon, color: AppColors.primary),
      onTap: onTap,
    );
  }
}
