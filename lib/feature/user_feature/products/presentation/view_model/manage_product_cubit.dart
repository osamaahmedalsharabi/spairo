import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repo.dart';
import 'manage_product_state.dart';

class ManageProductCubit extends Cubit<ManageProductState> {
  final ProductsRepo repository;

  ManageProductCubit({required this.repository})
    : super(ManageProductInitial());

  Future<void> addProduct(ProductEntity product) async {
    emit(ManageProductLoading());
    final result = await repository.addProduct(product);
    if (isClosed) return;
    result.fold(
      (failureMessage) => emit(ManageProductFailure(failureMessage)),
      (_) => emit(const ManageProductSuccess('تم إضافة المنتج بنجاح')),
    );
  }

  Future<void> updateProduct(ProductEntity product) async {
    emit(ManageProductLoading());
    final result = await repository.updateProduct(product);
    if (isClosed) return;
    result.fold(
      (failureMessage) => emit(ManageProductFailure(failureMessage)),
      (_) => emit(const ManageProductSuccess('تم تحديث المنتج بنجاح')),
    );
  }

  Future<void> deleteProduct(String productId) async {
    emit(ManageProductLoading());
    final result = await repository.deleteProduct(productId);
    if (isClosed) return;
    result.fold(
      (failureMessage) => emit(ManageProductFailure(failureMessage)),
      (_) => emit(const ManageProductSuccess('تم حذف المنتج بنجاح')),
    );
  }
}
