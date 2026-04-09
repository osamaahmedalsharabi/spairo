import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/Authantication/data/models/user_model.dart';
import 'expert_detail_header_widget.dart';
import 'expert_detail_info_section_widget.dart';
import 'expert_detail_actions_widget.dart';
import 'expert_location_map_widget.dart';

class ExpertDetailSheetWidget extends StatelessWidget {
  final UserModel expert;
  const ExpertDetailSheetWidget({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    final hasLoc = expert.location != null && expert.location!.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          ExpertDetailHeaderWidget(expert: expert),
          const SizedBox(height: 20),
          const Divider(),
          ExpertDetailInfoSectionWidget(expert: expert),
          const Divider(),
          if (hasLoc) ...[
            const SizedBox(height: 12),
            ExpertLocationMapWidget(locationName: expert.location!),
            const SizedBox(height: 12),
            const Divider(),
          ],
          const SizedBox(height: 12),
          ExpertDetailActionsWidget(expert: expert),
          const SizedBox(height: 16),
        ],
      )),
    );
  }
}
