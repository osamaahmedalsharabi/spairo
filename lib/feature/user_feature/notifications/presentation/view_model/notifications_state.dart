part of 'notifications_cubit.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> items;
  NotificationsLoaded(this.items);
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}
