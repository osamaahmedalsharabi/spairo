import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repositories/products_repo.dart';
import 'search_products_state.dart';

class SearchProductsCubit extends Cubit<SearchProductsState> {
  final ProductsRepo _productsRepo;
  List<ProductEntity> _allProducts = []; 

  String _currentQuery = '';
  List<String>? matchedProductIds;
  String? selectedBrand;
  String? selectedCar;
  String? selectedCategory;
  String? selectedCondition;
  String? selectedYear;
  double? minPrice;
  double? maxPrice;

  SearchProductsCubit(this._productsRepo) : super(SearchProductsInitial());

  double get absoluteMaxPrice {
    if (_allProducts.isEmpty) return 1000.0;
    return _allProducts.map((p) => p.price).reduce((a, b) => a > b ? a : b);
  }

  List<String> get uniqueBrands => _allProducts.map((p) => p.brandName).where((e) => e.isNotEmpty).toSet().toList()..sort();
  List<String> get uniqueCars => _allProducts.map((p) => p.carName).where((e) => e.isNotEmpty).toSet().toList()..sort();
  List<String> get uniqueCategories => _allProducts.map((p) => p.categoryName).where((e) => e.isNotEmpty).toSet().toList()..sort();
  List<String> get uniqueConditions => _allProducts.map((p) => p.condition).where((e) => e.isNotEmpty).toSet().toList()..sort();
  List<String> get uniqueYears => _allProducts.map((p) => p.modelYear).where((e) => e.isNotEmpty).toSet().toList()..sort((a,b) => b.compareTo(a));

  Future<void> initSearch() async {
    emit(SearchProductsLoading());
    final result = await _productsRepo.getAllProducts();
    result.fold(
      (failure) => emit(SearchProductsFailure(message: failure)),
      (products) {
        _allProducts = products;
        _runSearch();
      },
    );
  }

  void searchProduct(String query) {
    _currentQuery = query;
    matchedProductIds = null;
    _runSearch();
  }

  void searchProductsByIds(List<String> ids, [String query = '']) {
    _currentQuery = query;
    matchedProductIds = ids;
    _runSearch();
  }

  void applyFilters({
    String? brand,
    String? car,
    String? category,
    String? condition,
    String? year,
    double? min,
    double? max,
  }) {
    selectedBrand = brand;
    selectedCar = car;
    selectedCategory = category;
    selectedCondition = condition;
    selectedYear = year;
    minPrice = min;
    maxPrice = max;
    _runSearch();
  }

  void clearFilters() {
    selectedBrand = null;
    selectedCar = null;
    selectedCategory = null;
    selectedCondition = null;
    selectedYear = null;
    minPrice = null;
    maxPrice = null;
    _runSearch();
  }

  void _runSearch() {
    if (matchedProductIds != null && matchedProductIds!.isNotEmpty) {
      final filtered = _allProducts.where((p) => matchedProductIds!.contains(p.id)).toList();
      if (filtered.isNotEmpty) {
        emit(SearchProductsSuccess(products: filtered));
        return;
      }
    }

    final String lowerQuery = _currentQuery.toLowerCase();
    
    final filtered = _allProducts.where((product) {
      bool matchesQuery = true;
      if (lowerQuery.isNotEmpty) {
        matchesQuery = product.name.toLowerCase().contains(lowerQuery);
      }
      
      bool matchesBrand = selectedBrand == null || product.brandName == selectedBrand;
      bool matchesCar = selectedCar == null || product.carName == selectedCar;
      bool matchesCategory = selectedCategory == null || product.categoryName == selectedCategory;
      bool matchesCondition = selectedCondition == null || product.condition == selectedCondition;
      bool matchesYear = selectedYear == null || product.modelYear == selectedYear;

      bool matchesPrice = true;
      if (minPrice != null && product.price < minPrice!) matchesPrice = false;
      if (maxPrice != null && product.price > maxPrice!) matchesPrice = false;

      return matchesQuery && matchesBrand && matchesCar && matchesCategory && matchesCondition && matchesYear && matchesPrice;
    }).toList();

    emit(SearchProductsSuccess(products: filtered));
  }
}
