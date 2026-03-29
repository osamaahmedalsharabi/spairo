import 'dart:io';
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.supplierId,
    required super.name,
    required super.description,
    required super.price,
    required super.quantity,
    required super.brandName,
    required super.carName,
    required super.categoryName,
    required super.modelYear,
    required super.condition,
    required super.image,
    super.localImage,
    super.isApproved = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String id) {
    return ProductModel(
      id: id,
      supplierId: json['supplierId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      brandName: json['brandName'] as String? ?? '',
      carName: json['carName'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      modelYear: json['modelYear'] as String? ?? '',
      condition: json['condition'] as String? ?? '',
      image: json['image'] as String? ?? '',
      isApproved: json['isApproved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplierId': supplierId,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'brandName': brandName,
      'carName': carName,
      'categoryName': categoryName,
      'modelYear': modelYear,
      'condition': condition,
      'image': image,
      'isApproved': isApproved,
    };
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      supplierId: entity.supplierId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      quantity: entity.quantity,
      brandName: entity.brandName,
      carName: entity.carName,
      categoryName: entity.categoryName,
      modelYear: entity.modelYear,
      condition: entity.condition,
      image: entity.image,
      localImage: entity.localImage,
      isApproved: entity.isApproved,
    );
  }
}
