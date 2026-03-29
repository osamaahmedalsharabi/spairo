part of 'admin_cubit.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<UserEntity> users;
  final List<PartOrderModel> orders;
  final List<ProductEntity> pendingProducts;
  final List<ProductEntity> allProducts;
  final List<BrandModel> brands;
  final List<CategoryModel> categories;
  final AdminStats stats;
  AdminLoaded({
    required this.users,
    required this.orders,
    required this.pendingProducts,
    required this.allProducts,
    required this.brands,
    required this.categories,
    required this.stats,
  });
}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}

class AdminStats {
  final int totalUsers;
  final int suppliers;
  final int engineers;
  final int regularUsers;
  final int activeUsers;
  final int totalOrders;
  final int completedOrders;
  final double totalRevenue;
  final int pendingProducts;
  final int totalProducts;

  AdminStats({
    required this.totalUsers,
    required this.suppliers,
    required this.engineers,
    required this.regularUsers,
    required this.activeUsers,
    required this.totalOrders,
    required this.completedOrders,
    required this.totalRevenue,
    required this.pendingProducts,
    required this.totalProducts,
  });

  factory AdminStats.compute(
    List<UserEntity> users,
    List<PartOrderModel> orders,
    int pendingCount,
    int totalProductsCount,
  ) {
    return AdminStats(
      totalUsers: users.length,
      suppliers: users
          .where((u) => u.userType == 'مورد')
          .length,
      engineers: users
          .where((u) => u.userType == 'مهندس')
          .length,
      regularUsers: users
          .where((u) => u.userType == 'مستخدم')
          .length,
      activeUsers:
          users.where((u) => u.isActive).length,
      totalOrders: orders.length,
      completedOrders: orders
          .where(
              (o) => o.status == OrderStatus.completed)
          .length,
      totalRevenue: orders
          .where(
              (o) => o.status == OrderStatus.completed)
          .fold(0, (s, o) => s + (o.productPrice ?? 0)),
      pendingProducts: pendingCount,
      totalProducts: totalProductsCount,
    );
  }
}
