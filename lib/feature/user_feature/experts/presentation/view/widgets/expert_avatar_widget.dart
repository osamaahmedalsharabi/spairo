import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class ExpertAvatarWidget extends StatelessWidget {
  final double size;
  final double iconSize;

  const ExpertAvatarWidget({
    super.key,
    this.size = 60,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.engineering,
        color: AppColors.primary,
        size: iconSize,
      ),
    );
  }
}
