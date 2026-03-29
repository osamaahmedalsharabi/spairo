import '../models/notification_model.dart';

abstract class NotificationsRepository {
  Future<List<NotificationModel>> getNotifications(String uid);
  Future<void> markAsRead(String notificationId);
}
