import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class SearchProductsState extends Equatable {
  const SearchProductsState();

  @override
  List<Object> get props => [];
}

class SearchProductsInitial extends SearchProductsState {}

class SearchProductsLoading extends SearchProductsState {}

class SearchProductsSuccess extends SearchProductsState {
  final List<ProductEntity> products;
  const SearchProductsSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

class SearchProductsFailure extends SearchProductsState {
  final String message;
  const SearchProductsFailure({required this.message});

  @override
  List<Object> get props => [message];
}
