import 'package:dartz/dartz.dart';
import '../../../products/domain/entities/product_entity.dart';

abstract class FavoritesRepo {
  Future<Either<String, List<ProductEntity>>> getFavorites(
      String uid);

  Future<Either<String, bool>> toggleFavorite(
      String uid, ProductEntity product);

  Future<bool> isFavorite(String uid, String productId);
}
