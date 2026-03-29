import 'package:cloud_firestore/cloud_firestore.dart';
import '../../feature/user_feature/part_order/data/models/part_order_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send an order notification to the supplier
  Future<void> sendOrderNotificationToSupplier(PartOrderModel order) async {
    if (order.supplierId == null) return;

    final partLabel = order.partName.isNotEmpty
        ? order.partName
        : order.categoryName;

    try {
      await _firestore.collection('notifications').add({
        'receiverId': order.supplierId,
        'title': 'طلب قطع جديد 🎉',
        'body': 'العميل قام بطلب القطعة: $partLabel (طلب رقم ${order.orderNumber}). اضغط لعرض التفاصيل.',
        'orderId': order.id ?? '',
        'type': 'new_order',
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
        'senderId': order.uid,
        'image': order.orderImage ?? '',
      });
    } catch (e) {
      print('Error saving order notification: $e');
    }
  }

  // Send a status update notification to the customer
  Future<void> sendOrderStatusNotification(PartOrderModel order) async {
    // Determine the status text based on order.status
    String statusTitle;
    String statusBody;

    switch (order.status) {
      case OrderStatus.pending:
        statusTitle = 'الطلب قيد المراجعة ⏳';
        statusBody = 'تم إرسال طلبك (${order.orderNumber}) للمراجعة بنجاح.';
        break;
      case OrderStatus.inProgress:
        statusTitle = 'طلبك قيد التنفيذ ⚙️';
        statusBody = 'جاري العمل على تجهيز طلبك (${order.orderNumber}).';
        break;
      case OrderStatus.completed:
        statusTitle = 'تم اكتمال طلبك ✅';
        statusBody = 'مبروك! طلبك (${order.orderNumber}) للقطعة ${order.partName} اكتمل.';
        break;
      case OrderStatus.cancelled:
        statusTitle = 'تم إلغاء طلبك ❌';
        statusBody = 'عذراً، تم إلغاء طلبك (${order.orderNumber}). لمزيد من التفاصيل يرجى مراجعة التطبيق.';
        break;
    }

    try {
      await _firestore.collection('notifications').add({
        'receiverId': order.uid, // The customer
        'title': statusTitle,
        'body': statusBody,
        'orderId': order.id ?? '',
        'type': 'order_status_update',
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
        'senderId': order.supplierId ?? 'system', 
        'image': order.orderImage ?? '',
      });
    } catch (e) {
      print('Error saving order status notification: $e');
    }
  }
}
