import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:sparioapp/Core/errors/firebase_error_helper.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';

class PartOrderRepoImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Either<String, PartOrderModel>> submitOrder(
    PartOrderModel order,
    File? image,
  ) async {
    try {
      PartOrderModel finalOrder = order;

      if (image != null) {
        final ref = _storage.ref().child(
          'order_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        finalOrder = order.copyWith(orderImage: url);
      }

      final docRef = await _firestore.collection('order').add(finalOrder.toJson());
      return Right(finalOrder.copyWith(id: docRef.id));
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  Future<Either<String, List<PartOrderModel>>> getUserOrders(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('order')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      final orders = snapshot.docs.map((doc) {
        final data = doc.data();
        return _orderFromDoc(doc.id, data);
      }).toList();

      return Right(orders);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  Future<Either<String, List<PartOrderModel>>> getSupplierOrders(
    String supplierId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('order')
          .where('supplierId', isEqualTo: supplierId)
          .where('senderType', isEqualTo: 'مورد')
          .get();

      final orders = snapshot.docs.map((doc) {
        final data = doc.data();
        return _orderFromDoc(doc.id, data);
      }).toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(orders);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  Future<Either<String, List<PartOrderModel>>> getIncomingSupplierOrders(
    String supplierId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('order')
          .where('supplierId', isEqualTo: supplierId)
          .get();

      final orders = snapshot.docs.map((doc) {
        final data = doc.data();
        return _orderFromDoc(doc.id, data);
      }).toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(orders);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  Future<Either<String, void>> cancelOrder(String orderId) async {
    return updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  Future<Either<String, void>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      await _firestore.collection('order').doc(orderId).update({
        'status': status.name,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  PartOrderModel _orderFromDoc(
    String docId,
    Map<String, dynamic> data,
  ) {
    return PartOrderModel(
      id: docId,
      uid: data['uid'] ?? '',
      orderNumber: data['orderNumber'] ?? '',
      status: OrderStatusExtension.fromString(data['status'] ?? ''),
      companyName: data['companyName'] ?? '',
      companyImage: data['companyImage'] ?? '',
      carName: data['carName'] ?? '',
      carImage: data['carImage'] ?? '',
      categoryName: data['categoryName'] ?? '',
      categoryImage: data['categoryImage'] ?? '',
      carYear: data['carYear'] ?? '',
      condition: data['condition'] ?? '',
      partNumber: data['partNumber'] ?? '',
      partName: data['partName'] ?? '',
      details: data['details'] ?? '',
      orderImage: data['orderImage'],
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      supplierId: data['supplierId'],
      productId: data['productId'],
      productPrice: (data['productPrice'] as num?)?.toDouble(),
      senderType: data['senderType'],
      shippingMethod: data['shippingMethod'],
      deliveryAddress: data['deliveryAddress'],
      paymentMethod: data['paymentMethod'],
    );
  }
}
