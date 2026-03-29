import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sparioapp/feature/Authantication/data/models/user_model.dart';
import 'expert_card_widget.dart';

class ExpertShimmerWidget extends StatelessWidget {
  const ExpertShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mockExpert = UserModel(
      id: '0',
      name: 'اسم الخبير محمل...',
      email: '',
      phone: '',
      userType: 'مهندس',
    );

    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: 6,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return ExpertCardWidget(expert: mockExpert);
        },
      ),
    );
  }
}
