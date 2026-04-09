import 'package:bloc/bloc.dart';
import 'package:sparioapp/feature/user_feature/products/domain/repositories/products_repo.dart';
import 'filtered_products_state.dart';

class FilteredProductsCubit extends Cubit<FilteredProductsState> {
  final ProductsRepo _productsRepo;

  FilteredProductsCubit(this._productsRepo) : super(FilteredProductsInitial());

  Future<void> getProductsByBrand(String brandName) async {
    emit(FilteredProductsLoading());
    final result = await _productsRepo.getProductsByBrandName(brandName);
    result.fold(
      (failure) => emit(FilteredProductsFailure(message: failure)),
      (products) => emit(FilteredProductsSuccess(products: products)),
    );
  }

  Future<void> getProductsByCategory(String categoryName) async {
    emit(FilteredProductsLoading());
    final result = await _productsRepo.getProductsByCategoryName(categoryName);
    result.fold(
      (failure) => emit(FilteredProductsFailure(message: failure)),
      (products) => emit(FilteredProductsSuccess(products: products)),
    );
  }

  Future<void> getProductsByCar(String carName) async {
    emit(FilteredProductsLoading());
    final result = await _productsRepo.getProductsByCarName(carName);
    result.fold(
      (failure) => emit(FilteredProductsFailure(message: failure)),
      (products) => emit(FilteredProductsSuccess(products: products)),
    );
  }

  Future<void> getProductsBySupplier(String supplierId) async {
    emit(FilteredProductsLoading());
    final result = await _productsRepo.getProductsBySupplierId(supplierId);
    result.fold(
      (failure) => emit(FilteredProductsFailure(message: failure)),
      (products) => emit(FilteredProductsSuccess(products: products)),
    );
  }

  Future<void> getAllProducts() async {
    emit(FilteredProductsLoading());
    final result = await _productsRepo.getAllProducts();
    result.fold(
      (failure) => emit(FilteredProductsFailure(message: failure)),
      (products) => emit(FilteredProductsSuccess(products: products)),
    );
  }

  Future<void> getProductsByMultipleFilters({
    required String carName,
    required String year,
    required String categoryName,
  }) async {
    emit(FilteredProductsLoading());
    final result = await _productsRepo.getProductsByCarName(carName);
    result.fold(
      (failure) => emit(FilteredProductsFailure(message: failure)),
      (products) {
        final filtered = products.where((p) {
          return p.modelYear == year && p.categoryName == categoryName;
        }).toList();
        
        emit(FilteredProductsSuccess(products: filtered));
      },
    );
  }

  Future<void> getCompatibleParts({
    required String carName,
    required String year,
  }) async {
    emit(FilteredProductsLoading());
    final result = await _productsRepo.getProductsByCarName(carName);
    result.fold(
      (failure) => emit(FilteredProductsFailure(message: failure)),
      (products) {
        final filtered = products.where((p) {
          return p.modelYear == year;
        }).toList();
        
        emit(FilteredProductsSuccess(products: filtered));
      },
    );
  }
}
