import 'package:flutter/material.dart';
import 'package:sparioapp/feature/Authantication/data/models/user_model.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'expert_avatar_widget.dart';
import 'expert_card_details_widget.dart';
import 'expert_detail_sheet_widget.dart';

class ExpertCardWidget extends StatelessWidget {
  final UserModel expert;

  const ExpertCardWidget({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showExpertDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withAlpha(80),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const ExpertAvatarWidget(),
              const SizedBox(width: 16),
              ExpertCardDetailsWidget(expert: expert),
            ],
          ),
        ),
      ),
    );
  }

  void _showExpertDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExpertDetailSheetWidget(expert: expert),
    );
  }
}
