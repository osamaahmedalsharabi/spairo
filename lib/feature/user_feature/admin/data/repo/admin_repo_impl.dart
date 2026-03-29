import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:sparioapp/Core/errors/firebase_error_helper.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'package:sparioapp/feature/user_feature/products/data/models/product_model.dart';
import 'package:sparioapp/feature/user_feature/products/domain/entities/product_entity.dart';
import 'admin_repo.dart';

class AdminRepoImpl implements AdminRepo {
  final FirebaseFirestore _db;
  AdminRepoImpl(this._db);

  @override
  Future<Either<String, List<UserEntity>>> getAllUsers() async {
    try {
      final snap = await _db.collection('users').get();
      final users = snap.docs.map((doc) {
        final d = doc.data();
        return UserEntity(
          id: doc.id,
          name: d['name'] ?? '',
          email: d['email'] ?? '',
          phone: d['phone'] ?? '',
          userType: d['userType'] ?? '',
          commercialRegisterImage: d['commercialRegisterImage'],
          isActive: d['is_active'] ?? false,
        );
      }).toList();
      return Right(users);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, List<PartOrderModel>>> getAllOrders() async {
    try {
      final snap = await _db
          .collection('order')
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();
      final orders = snap.docs.map((doc) {
        final d = doc.data();
        return PartOrderModel(
          id: doc.id,
          uid: d['uid'] ?? '',
          orderNumber: d['orderNumber'] ?? '',
          status: OrderStatusExtension.fromString(
              d['status'] ?? 'pending'),
          companyName: d['companyName'] ?? '',
          companyImage: d['companyImage'] ?? '',
          carName: d['carName'] ?? '',
          carImage: d['carImage'] ?? '',
          categoryName: d['categoryName'] ?? '',
          categoryImage: d['categoryImage'] ?? '',
          carYear: d['carYear'] ?? '',
          condition: d['condition'] ?? '',
          partNumber: d['partNumber'] ?? '',
          partName: d['partName'] ?? '',
          details: d['details'] ?? '',
          orderImage: d['orderImage'],
          createdAt: (d['createdAt'] as Timestamp?)
                  ?.toDate() ??
              DateTime.now(),
          supplierId: d['supplierId'],
          productId: d['productId'],
          productPrice: (d['productPrice'] as num?)?.toDouble(),
          senderType: d['senderType'],
        );
      }).toList();
      return Right(orders);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, void>> toggleUserActive(
      String userId, bool isActive) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .update({'is_active': isActive});
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, void>> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getPendingProducts() async {
    try {
      final snap = await _db
          .collection('products')
          .where('isApproved', isEqualTo: false)
          .get();
      final products = snap.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, void>> approveProduct(String productId) async {
    try {
      await _db.collection('products').doc(productId)
          .update({'isApproved': true});
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, void>> rejectProduct(String productId) async {
    try {
      await _db.collection('products').doc(productId).delete();
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getAllProducts() async {
    try {
      final snap = await _db.collection('products').get();
      final products = snap.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, void>> toggleProductApproval(
      String productId, bool isApproved) async {
    try {
      await _db.collection('products').doc(productId)
          .update({'isApproved': isApproved});
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  Future<String> _uploadImage(
      File file, String folder) async {
    final storage = FirebaseStorage.instance;
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}'
        '_${p.basename(file.path)}';
    final ref =
        storage.ref().child('$folder/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  @override
  Future<Either<String, void>> addBrand(
      String name, File? image) async {
    try {
      String imageUrl = '';
      if (image != null) {
        imageUrl =
            await _uploadImage(image, 'brands');
      }
      await _db.collection('brands').add({
        'name': name,
        'image': imageUrl,
      });
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, void>> addCarToBrand(
      String brandId, String name,
      File? image) async {
    try {
      String imageUrl = '';
      if (image != null) {
        imageUrl =
            await _uploadImage(image, 'cars');
      }
      await _db
          .collection('brands')
          .doc(brandId)
          .collection('cars')
          .add({'name': name, 'image': imageUrl});
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, void>> addCategory(
      String name, File? image) async {
    try {
      String imageUrl = '';
      if (image != null) {
        imageUrl = await _uploadImage(
            image, 'categories');
      }
      await _db
          .collection('Auto parts classifications')
          .add({'name': name, 'image': imageUrl});
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }
}
