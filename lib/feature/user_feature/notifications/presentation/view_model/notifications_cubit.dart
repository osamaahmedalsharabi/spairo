import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/notifications_repository.dart';
import '../../data/models/notification_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repo;

  NotificationsCubit(this._repo) : super(NotificationsInitial());

  Future<void> load() async {
    emit(NotificationsLoading());
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(NotificationsError("يجب تسجيل الدخول لعرض الإشعارات"));
        return;
      }
      final data = await _repo.getNotifications(uid);
      emit(NotificationsLoaded(data));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repo.markAsRead(notificationId);
      // reload after marking to update UI
      load();
    } catch (e) {
      // Handle error quietly
    }
  }
}
