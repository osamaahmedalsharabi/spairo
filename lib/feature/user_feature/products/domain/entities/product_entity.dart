import 'dart:io';

import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String supplierId; // ID of the supplier who added the product
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String brandName;
  final String carName;
  final String categoryName;
  final String modelYear;
  final String condition;
  final String image;
  final File? localImage; // Used when picking a new image before upload
  final bool isApproved;

  const ProductEntity({
    required this.id,
    required this.supplierId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.brandName,
    required this.carName,
    required this.categoryName,
    required this.modelYear,
    required this.condition,
    required this.image,
    this.localImage,
    this.isApproved = false,
  });

  @override
  List<Object?> get props => [
    id,
    supplierId,
    name,
    description,
    price,
    quantity,
    brandName,
    carName,
    categoryName,
    modelYear,
    condition,
    image,
    localImage,
    isApproved,
  ];
}
