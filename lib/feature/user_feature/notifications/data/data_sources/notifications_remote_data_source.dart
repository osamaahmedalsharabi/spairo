import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(String uid);
  Future<void> markAsRead(String id);
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final FirebaseFirestore _firestore;

  NotificationsRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<NotificationModel>> getNotifications(String uid) async {
    final snap = await _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: uid)
        .get();
        
    final list = snap.docs
        .map((d) => NotificationModel.fromJson(d.data(), d.id))
        .toList();
    
    // Sort by createdAt descending (client-side to avoid composite index)
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    // Limit to 30 most recent
    if (list.length > 30) return list.sublist(0, 30);
    return list;
  }

  @override
  Future<void> markAsRead(String id) async {
    await _firestore
        .collection('notifications')
        .doc(id)
        .update({'isRead': true});
  }
}
