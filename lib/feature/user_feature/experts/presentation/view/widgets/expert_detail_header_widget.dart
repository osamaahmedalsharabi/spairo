import 'package:flutter/material.dart';
import 'package:sparioapp/feature/Authantication/data/models/user_model.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'expert_avatar_widget.dart';

class ExpertDetailHeaderWidget extends StatelessWidget {
  final UserModel expert;

  const ExpertDetailHeaderWidget({
    super.key,
    required this.expert,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExpertAvatarWidget(size: 80, iconSize: 40),
        const SizedBox(height: 12),
        Text(
          expert.name.isNotEmpty ? expert.name : 'مهندس السبايرو',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "ميكانيك سيارات",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
