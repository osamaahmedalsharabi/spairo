import '../models/notification_model.dart';
import '../repositories/notifications_repository.dart';
import '../data_sources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;

  NotificationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<NotificationModel>> getNotifications(String uid) {
    return _remoteDataSource.getNotifications(uid);
  }

  @override
  Future<void> markAsRead(String id) {
    return _remoteDataSource.markAsRead(id);
  }
}
