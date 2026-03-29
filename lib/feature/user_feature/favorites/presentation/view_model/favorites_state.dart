part of 'favorites_cubit.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<ProductEntity> products;
  final Set<String> favoriteIds;
  FavoritesLoaded(this.products, this.favoriteIds);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}
