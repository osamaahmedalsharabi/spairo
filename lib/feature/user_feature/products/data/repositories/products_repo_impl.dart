import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dartz/dartz.dart';

import 'package:sparioapp/Core/errors/firebase_error_helper.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repo.dart';
import '../models/product_model.dart';
import 'package:path/path.dart' as p;

class ProductsRepoImpl implements ProductsRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<Either<String, List<ProductEntity>>> getAllProducts() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('isApproved', isEqualTo: true)
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();

      return Right(products);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getSupplierProducts(
    String supplierId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('supplierId', isEqualTo: supplierId)
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();

      return Right(products);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getProductsByBrandName(
    String brandName,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('brandName', isEqualTo: brandName)
          .where('isApproved', isEqualTo: true)
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();

      return Right(products);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getProductsByCategoryName(
    String categoryName,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('categoryName', isEqualTo: categoryName)
          .where('isApproved', isEqualTo: true)
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();

      return Right(products);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getProductsByCarName(
    String carName,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('carName', isEqualTo: carName)
          .where('isApproved', isEqualTo: true)
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();

      return Right(products);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getProductsBySupplierId(
    String supplierId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('supplierId', isEqualTo: supplierId)
          .where('isApproved', isEqualTo: true)
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();

      return Right(products);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, void>> addProduct(ProductEntity product) async {
    try {
      String imageUrl = product.image;

      if (product.localImage != null) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${p.basename(product.localImage!.path)}';
        final ref = _storage.ref().child('product_images/$fileName');
        await ref.putFile(product.localImage!);
        imageUrl = await ref.getDownloadURL();
      }

      final docRef = _firestore.collection('products').doc();

      // Update model with actual Firestore document ID
      final finalModel = ProductModel(
        id: docRef.id,
        supplierId: product.supplierId,
        name: product.name,
        description: product.description,
        price: product.price,
        quantity: product.quantity,
        brandName: product.brandName,
        carName: product.carName,
        categoryName: product.categoryName,
        modelYear: product.modelYear,
        condition: product.condition,
        image: imageUrl,
      );

      await docRef.set(finalModel.toJson());

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, void>> updateProduct(ProductEntity product) async {
    try {
      String imageUrl = product.image;

      // 1. Upload new image if provided
      if (product.localImage != null) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${p.basename(product.localImage!.path)}';
        final ref = _storage.ref().child('product_images/$fileName');
        await ref.putFile(product.localImage!);
        imageUrl = await ref.getDownloadURL();
      }

      // 2. Update product document in Firestore
      final productModel = ProductModel(
        id: product.id,
        supplierId: product.supplierId,
        name: product.name,
        description: product.description,
        price: product.price,
        quantity: product.quantity,
        brandName: product.brandName,
        carName: product.carName,
        categoryName: product.categoryName,
        modelYear: product.modelYear,
        condition: product.condition,
        image: imageUrl,
      );

      await _firestore
          .collection('products')
          .doc(product.id)
          .update(productModel.toJson());

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, void>> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  Future<Either<String, List<ProductEntity>>> getPendingProducts() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('isApproved', isEqualTo: false)
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  Future<Either<String, void>> approveProduct(String productId) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .update({'isApproved': true});
      return const Right(null);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  Future<Either<String, void>> rejectProduct(String productId) async {
    return deleteProduct(productId);
  }
}
