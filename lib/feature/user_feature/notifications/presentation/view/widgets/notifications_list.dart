import 'package:flutter/material.dart';
import '../../../data/models/notification_model.dart';
import 'notification_card.dart';

class NotificationsList extends StatelessWidget {
  final List<NotificationModel> items;

  const NotificationsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return NotificationCard(notification: items[index]);
      },
    );
  }
}
