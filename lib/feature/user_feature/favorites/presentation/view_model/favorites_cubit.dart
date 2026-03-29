import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../data/repo/favorites_repo.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepo _repo;

  FavoritesCubit(this._repo) : super(FavoritesInitial());

  Set<String> _favoriteIds = {};

  bool isFavorite(String productId) =>
      _favoriteIds.contains(productId);

  Future<void> loadFavorites() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    emit(FavoritesLoading());
    final result = await _repo.getFavorites(uid);
    result.fold(
      (error) => emit(FavoritesError(error)),
      (products) {
        _favoriteIds = products.map((p) => p.id).toSet();
        emit(FavoritesLoaded(products, _favoriteIds));
      },
    );
  }

  Future<void> toggleFavorite(ProductEntity product) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final result = await _repo.toggleFavorite(uid, product);
    result.fold(
      (error) => emit(FavoritesError(error)),
      (isNowFavorite) {
        if (isNowFavorite) {
          _favoriteIds.add(product.id);
        } else {
          _favoriteIds.remove(product.id);
        }
        loadFavorites();
      },
    );
  }
}
