import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'package:sparioapp/feature/user_feature/products/domain/entities/product_entity.dart';

abstract class AdminRepo {
  Future<Either<String, List<UserEntity>>> getAllUsers();
  Future<Either<String, List<PartOrderModel>>> getAllOrders();
  Future<Either<String, void>> toggleUserActive(
      String userId, bool isActive);
  Future<Either<String, void>> deleteUser(String userId);
  Future<Either<String, List<ProductEntity>>> getPendingProducts();
  Future<Either<String, void>> approveProduct(String productId);
  Future<Either<String, void>> rejectProduct(String productId);
  Future<Either<String, List<ProductEntity>>> getAllProducts();
  Future<Either<String, void>> toggleProductApproval(
      String productId, bool isApproved);
  Future<Either<String, void>> addBrand(
      String name, File? image);
  Future<Either<String, void>> addCarToBrand(
      String brandId, String name, File? image);
  Future<Either<String, void>> addCategory(
      String name, File? image);
}
