import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/products_repo.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo repository;

  ProductsCubit({required this.repository}) : super(ProductsInitial());

  Future<void> getAllProducts() async {
    emit(ProductsLoading());
    final result = await repository.getAllProducts();
    result.fold(
      (failureMessage) => emit(ProductsFailure(failureMessage.toString())),
      (products) => emit(ProductsSuccess(products)),
    );
  }

  Future<void> getSupplierProducts(String supplierId) async {
    emit(ProductsLoading());
    final result = await repository.getSupplierProducts(supplierId);
    result.fold(
      (failureMessage) => emit(ProductsFailure(failureMessage.toString())),
      (products) => emit(ProductsSuccess(products)),
    );
  }
}
