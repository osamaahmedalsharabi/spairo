import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';

abstract class ProductsRepo {
  Future<Either<String, List<ProductEntity>>> getSupplierProducts(
    String supplierId,
  );
  Future<Either<String, List<ProductEntity>>> getAllProducts();

  Future<Either<String, List<ProductEntity>>> getProductsByBrandName(
    String brandName,
  );

  Future<Either<String, List<ProductEntity>>> getProductsByCategoryName(
    String categoryName,
  );

  Future<Either<String, List<ProductEntity>>> getProductsByCarName(
    String carName,
  );

  Future<Either<String, List<ProductEntity>>> getProductsBySupplierId(
    String supplierId,
  );

  Future<Either<String, void>> addProduct(ProductEntity product);

  Future<Either<String, void>> updateProduct(ProductEntity product);

  Future<Either<String, void>> deleteProduct(String productId);
}
