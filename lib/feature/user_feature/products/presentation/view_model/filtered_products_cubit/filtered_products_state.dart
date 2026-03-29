import 'package:equatable/equatable.dart';
import 'package:sparioapp/feature/user_feature/products/domain/entities/product_entity.dart';

abstract class FilteredProductsState extends Equatable {
  const FilteredProductsState();
  
  @override
  List<Object> get props => [];
}

class FilteredProductsInitial extends FilteredProductsState {}

class FilteredProductsLoading extends FilteredProductsState {}

class FilteredProductsSuccess extends FilteredProductsState {
  final List<ProductEntity> products;

  const FilteredProductsSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

class FilteredProductsFailure extends FilteredProductsState {
  final String message;

  const FilteredProductsFailure({required this.message});

  @override
  List<Object> get props => [message];
}
