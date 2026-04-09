import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';

class ProfileUserTypeBadgeWidget extends StatelessWidget {
  final UserEntity user;

  const ProfileUserTypeBadgeWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.4),
        ),
      ),
      child: Text(
        user.userType,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
