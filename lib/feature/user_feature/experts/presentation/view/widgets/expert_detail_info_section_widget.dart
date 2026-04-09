import 'package:flutter/material.dart';
import 'package:sparioapp/feature/Authantication/data/models/user_model.dart';
import 'expert_detail_info_row_widget.dart';

class ExpertDetailInfoSectionWidget extends StatelessWidget {
  final UserModel expert;

  const ExpertDetailInfoSectionWidget({
    super.key, required this.expert,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ExpertDetailInfoRowWidget(
        icon: Icons.phone,
        label: 'رقم الهاتف',
        value: expert.phone.isNotEmpty
            ? expert.phone : 'غير متوفر',
      ),
      ExpertDetailInfoRowWidget(
        icon: Icons.email_outlined,
        label: 'البريد الإلكتروني',
        value: expert.email.isNotEmpty
            ? expert.email : 'غير متوفر',
      ),
      ExpertDetailInfoRowWidget(
        icon: Icons.badge_outlined,
        label: 'نوع الحساب',
        value: expert.userType,
      ),
      ExpertDetailInfoRowWidget(
        icon: Icons.location_on_outlined,
        label: 'الموقع',
        value: (expert.location != null &&
                expert.location!.isNotEmpty)
            ? expert.location!
            : 'غير محدد',
      ),
    ]);
  }
}
