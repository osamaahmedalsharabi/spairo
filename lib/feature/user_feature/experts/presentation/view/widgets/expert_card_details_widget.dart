import 'package:flutter/material.dart';
import 'package:sparioapp/feature/Authantication/data/models/user_model.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class ExpertCardDetailsWidget extends StatelessWidget {
  final UserModel expert;

  const ExpertCardDetailsWidget({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
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
              Text(expert.location ?? "صنعاء", style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
