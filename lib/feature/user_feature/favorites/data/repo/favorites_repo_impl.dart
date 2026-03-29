import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../products/domain/entities/product_entity.dart';
import 'favorites_repo.dart';

class FavoritesRepoImpl implements FavoritesRepo {
  final FirebaseFirestore _firestore;

  FavoritesRepoImpl(this._firestore);

  CollectionReference _favCol(String uid) =>
      _firestore.collection('users').doc(uid).collection('favorites');

  @override
  Future<Either<String, List<ProductEntity>>> getFavorites(
      String uid) async {
    try {
      final snap = await _favCol(uid).get();
      final list = snap.docs.map((doc) {
        final d = doc.data() as Map<String, dynamic>;
        return ProductEntity(
          id: doc.id,
          supplierId: d['supplierId'] ?? '',
          name: d['name'] ?? '',
          description: d['description'] ?? '',
          price: (d['price'] as num?)?.toDouble() ?? 0,
          quantity: (d['quantity'] as num?)?.toInt() ?? 0,
          brandName: d['brandName'] ?? '',
          carName: d['carName'] ?? '',
          categoryName: d['categoryName'] ?? '',
          modelYear: d['modelYear'] ?? '',
          condition: d['condition'] ?? '',
          image: d['image'] ?? '',
        );
      }).toList();
      return Right(list);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> toggleFavorite(
      String uid, ProductEntity product) async {
    try {
      final docRef = _favCol(uid).doc(product.id);
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.delete();
        return const Right(false);
      } else {
        await docRef.set(_toMap(product));
        return const Right(true);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<bool> isFavorite(String uid, String productId) async {
    final doc = await _favCol(uid).doc(productId).get();
    return doc.exists;
  }

  Map<String, dynamic> _toMap(ProductEntity p) => {
        'supplierId': p.supplierId,
        'name': p.name,
        'description': p.description,
        'price': p.price,
        'quantity': p.quantity,
        'brandName': p.brandName,
        'carName': p.carName,
        'categoryName': p.categoryName,
        'modelYear': p.modelYear,
        'condition': p.condition,
        'image': p.image,
      };
}
