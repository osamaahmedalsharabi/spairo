import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../data/models/notification_model.dart';
import '../../view_model/notifications_cubit.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;
    return GestureDetector(
      onTap: () {
        if (isUnread) {
          context.read<NotificationsCubit>().markAsRead(notification.id);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.primary.withOpacity(0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isUnread
              ? Border.all(color: AppColors.primary.withOpacity(0.3))
              : Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(),
            const SizedBox(width: 14),
            _buildContent(isUnread),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final hasImage = notification.image != null &&
        notification.image!.isNotEmpty;
    if (hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          notification.image!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultIcon(),
        ),
      );
    }
    return _defaultIcon();
  }

  Widget _defaultIcon() {
    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      child: const Icon(
        Icons.notifications_active_outlined,
        color: AppColors.primary,
        size: 26,
      ),
    );
  }

  Widget _buildContent(bool isUnread) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  isUnread ? FontWeight.bold : FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            notification.body,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            timeago.format(notification.createdAt, locale: 'ar'),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
