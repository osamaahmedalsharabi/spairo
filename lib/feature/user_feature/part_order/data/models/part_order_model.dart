import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, inProgress, completed, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'قيد المراجعة';
      case OrderStatus.inProgress:
        return 'قيد التنفيذ';
      case OrderStatus.completed:
        return 'مكتمل';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }

  static OrderStatus fromString(String val) {
    switch (val) {
      case 'inProgress':
        return OrderStatus.inProgress;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }
}

class PartOrderModel {
  final String? id;
  final String uid;
  final String orderNumber;
  final OrderStatus status;
  final String companyName;
  final String companyImage;
  final String carName;
  final String carImage;
  final String categoryName;
  final String categoryImage;
  final String carYear;
  final String condition;
  final String partNumber;
  final String partName;
  final String details;
  final String? orderImage;
  final DateTime createdAt;
  final String? supplierId;
  final String? productId;
  final double? productPrice;
  final String? senderType;
  final String? shippingMethod;
  final String? deliveryAddress;
  final String? paymentMethod;

  PartOrderModel({
    this.id,
    required this.uid,
    required this.orderNumber,
    required this.status,
    required this.companyName,
    required this.companyImage,
    required this.carName,
    required this.carImage,
    required this.categoryName,
    required this.categoryImage,
    required this.carYear,
    required this.condition,
    required this.partNumber,
    required this.partName,
    required this.details,
    this.orderImage,
    required this.createdAt,
    this.supplierId,
    this.productId,
    this.productPrice,
    this.senderType,
    this.shippingMethod,
    this.deliveryAddress,
    this.paymentMethod,
  });

  PartOrderModel copyWith({
    String? id,
    OrderStatus? status,
    String? orderImage,
    String? supplierId,
    String? productId,
    double? productPrice,
    String? senderType,
    String? shippingMethod,
    String? deliveryAddress,
    String? paymentMethod,
  }) {
    return PartOrderModel(
      id: id ?? this.id,
      uid: uid,
      orderNumber: orderNumber,
      status: status ?? this.status,
      companyName: companyName,
      companyImage: companyImage,
      carName: carName,
      carImage: carImage,
      categoryName: categoryName,
      categoryImage: categoryImage,
      carYear: carYear,
      condition: condition,
      partNumber: partNumber,
      partName: partName,
      details: details,
      orderImage: orderImage ?? this.orderImage,
      createdAt: createdAt,
      supplierId: supplierId ?? this.supplierId,
      productId: productId ?? this.productId,
      productPrice: productPrice ?? this.productPrice,
      senderType: senderType ?? this.senderType,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'orderNumber': orderNumber,
      'status': status.name,
      'companyName': companyName,
      'companyImage': companyImage,
      'carName': carName,
      'carImage': carImage,
      'categoryName': categoryName,
      'categoryImage': categoryImage,
      'carYear': carYear,
      'condition': condition,
      'partNumber': partNumber,
      'partName': partName,
      'details': details,
      if (orderImage != null) 'orderImage': orderImage,
      'createdAt': FieldValue.serverTimestamp(),
      if (supplierId != null) 'supplierId': supplierId,
      if (productId != null) 'productId': productId,
      if (productPrice != null) 'productPrice': productPrice,
      if (senderType != null) 'senderType': senderType,
      if (shippingMethod != null) 'shippingMethod': shippingMethod,
      if (deliveryAddress != null) 'deliveryAddress': deliveryAddress,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
    };
  }
}
