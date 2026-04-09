import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sparioapp/feature/Authantication/data/models/user_model.dart';
import 'expert_detail_action_widget.dart';

class ExpertDetailActionsWidget extends StatelessWidget {
  final UserModel expert;

  const ExpertDetailActionsWidget({
    super.key,
    required this.expert,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ExpertDetailActionWidget(
          icon: Icons.phone,
          label: 'اتصال',
          onTap: () => _launchPhone(),
          color: Colors.green,
        ),
        const SizedBox(width: 12),
        ExpertDetailActionWidget(
          icon: Icons.chat,
          label: 'واتساب',
          onTap: () => _launchWhatsApp(),
          color: const Color(0xFF25D366),
        ),
      ],
    );
  }

  Future<void> _launchPhone() async {
    if (expert.phone.isEmpty) return;
    final uri = Uri.parse('tel:${expert.phone}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchWhatsApp() async {
    if (expert.phone.isEmpty) return;
    final uri = Uri.parse('https://wa.me/${expert.phone}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
