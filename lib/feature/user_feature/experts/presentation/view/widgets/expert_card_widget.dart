import 'package:flutter/material.dart';
import 'package:sparioapp/feature/Authantication/data/models/user_model.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class ExpertCardWidget extends StatelessWidget {
  final UserModel expert;

  const ExpertCardWidget({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            _buildAvatar(),
            const SizedBox(width: 16),
            _buildDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.engineering, color: AppColors.primary, size: 30),
    );
  }

  Widget _buildDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expert.name.isNotEmpty ? expert.name : 'مهندس السبايرو',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            "ميكانيك سيارات ",
            style: TextStyle(color: AppColors.primary, fontSize: 14),
          ),
          Row(
            children: [
              Text(
                "الموقع : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
              Text("الرياض", style: TextStyle(fontSize: 14)),
              Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {},
                child: const Text(
                  "عرض الموقع",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
