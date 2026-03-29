import 'package:flutter/material.dart';
import 'package:sparioapp/feature/Authantication/data/models/user_model.dart';
import 'expert_card_widget.dart';

class ExpertsListWidget extends StatelessWidget {
  final List<UserModel> experts;

  const ExpertsListWidget({super.key, required this.experts});

  @override
  Widget build(BuildContext context) {
    if (experts.isEmpty) {
      return const Center(
        child: Text(
          'لا يوجد خبراء متاحين حالياً',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: experts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return ExpertCardWidget(expert: experts[index]);
      },
    );
  }
}
