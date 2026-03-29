import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/category_model.dart';
import 'package:sparioapp/feature/user_feature/home/data/repo/home_repo.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'package:sparioapp/feature/user_feature/products/domain/entities/product_entity.dart';
import '../../data/repo/admin_repo.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepo _repo;
  final HomeRepoImpl _homeRepo;
  AdminCubit(this._repo, this._homeRepo)
      : super(AdminInitial());

  Future<void> loadDashboard() async {
    emit(AdminLoading());
    final usersRes = await _repo.getAllUsers();
    final ordersRes = await _repo.getAllOrders();
    final pendingRes =
        await _repo.getPendingProducts();
    final allProductsRes =
        await _repo.getAllProducts();

    List<BrandModel> brands = [];
    List<CategoryModel> categories = [];
    try {
      brands = await _homeRepo.getBrands();
      categories = await _homeRepo.getCategories();
    } catch (_) {}

    final users = usersRes.fold(
        (_) => <UserEntity>[], (u) => u);
    final orders = ordersRes.fold(
        (_) => <PartOrderModel>[], (o) => o);
    final pending = pendingRes.fold(
        (_) => <ProductEntity>[], (p) => p);
    final allProducts = allProductsRes.fold(
        (_) => <ProductEntity>[], (p) => p);

    emit(AdminLoaded(
      users: users,
      orders: orders,
      pendingProducts: pending,
      allProducts: allProducts,
      brands: brands,
      categories: categories,
      stats: AdminStats.compute(
          users, orders, pending.length,
          allProducts.length),
    ));
  }

  Future<void> toggleUserActive(
      String userId, bool isActive) async {
    final res = await _repo.toggleUserActive(
        userId, isActive);
    res.fold((_) {}, (_) => loadDashboard());
  }

  Future<void> deleteUser(String userId) async {
    final res = await _repo.deleteUser(userId);
    res.fold((_) {}, (_) => loadDashboard());
  }

  Future<void> approveProduct(String id) async {
    final res = await _repo.approveProduct(id);
    res.fold((_) {}, (_) => loadDashboard());
  }

  Future<void> rejectProduct(String id) async {
    final res = await _repo.rejectProduct(id);
    res.fold((_) {}, (_) => loadDashboard());
  }

  Future<void> toggleProductApproval(
      String id, bool isApproved) async {
    final res = await _repo.toggleProductApproval(
        id, isApproved);
    res.fold((_) {}, (_) => loadDashboard());
  }

  Future<void> addBrand(
      String name, File? image) async {
    final res =
        await _repo.addBrand(name, image);
    res.fold((_) {}, (_) => loadDashboard());
  }

  Future<void> addCarToBrand(String brandId,
      String name, File? image) async {
    final res = await _repo.addCarToBrand(
        brandId, name, image);
    res.fold((_) {}, (_) => loadDashboard());
  }

  Future<void> addCategory(
      String name, File? image) async {
    final res =
        await _repo.addCategory(name, image);
    res.fold((_) {}, (_) => loadDashboard());
  }

  Future<List<BrandModel>> getBrandCars(
      String brandId) async {
    try {
      return await _homeRepo.getBrandCars(brandId);
    } catch (_) {
      return [];
    }
  }
}
