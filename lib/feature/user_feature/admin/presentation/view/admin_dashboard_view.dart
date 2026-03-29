import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/user_feature/home/data/repo/home_repo.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'package:sparioapp/feature/user_feature/products/domain/entities/product_entity.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';

import '../../data/repo/admin_repo_impl.dart';
import '../view_model/admin_cubit.dart';
import 'widgets/admin_all_products_list.dart';
import 'widgets/admin_brands_sheet.dart';
import 'widgets/admin_cars_sheet.dart';
import 'widgets/admin_categories_sheet.dart';
import 'widgets/admin_manage_section.dart';
import 'widgets/admin_stats_cards.dart';
import 'widgets/admin_user_card.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCubit(
        AdminRepoImpl(FirebaseFirestore.instance),
        HomeRepoImpl(FirebaseFirestore.instance),
      )..loadDashboard(),
      child: const _DashboardBody(),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text('لوحة التحكم',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios,
              color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(
                child: CircularProgressIndicator());
          }
          if (state is AdminLoaded) {
            return _buildDashboard(context, state);
          }
          if (state is AdminError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDashboard(
      BuildContext context, AdminLoaded state) {
    return RefreshIndicator(
      onRefresh: () =>
          context.read<AdminCubit>().loadDashboard(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('إحصائيات المنصة'),
            const SizedBox(height: 12),
            AdminStatsCards(
              stats: state.stats,
              onCardTap: (type) => _showDetail(
                  context, type, state),
            ),
            const SizedBox(height: 24),
            _sectionTitle('إدارة المحتوى'),
            const SizedBox(height: 12),
            AdminManageSection(
              onBrandsTap: () =>
                  _showBrandsSheet(context, state),
              onCategoriesTap: () =>
                  _showCategoriesSheet(
                      context, state),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ));
  }

  void _showBrandsSheet(
      BuildContext context, AdminLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AdminCubit>(),
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, controller) => Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: controller,
              children: [
                Center(child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(
                      bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                )),
                const Text('إدارة البراندات',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 16),
                AdminBrandsSheet(
                  brands: state.brands,
                  onBrandTap: (brand) {
                    Navigator.pop(context);
                    _showCarsSheet(context, brand);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCarsSheet(BuildContext context,
      dynamic brand) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AdminCubit>(),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, controller) => Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: controller,
              children: [
                Center(child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(
                      bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                )),
                AdminCarsSheet(brand: brand),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCategoriesSheet(
      BuildContext context, AdminLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AdminCubit>(),
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, controller) => Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: controller,
              children: [
                Center(child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(
                      bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                )),
                const Text('إدارة الأصناف',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 16),
                AdminCategoriesSheet(
                    categories: state.categories),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context,
      String type, AdminLoaded state) {
    late String title;
    late Widget content;

    switch (type) {
      case 'totalUsers':
        title = 'جميع المستخدمين';
        content = _usersList(context, state.users);
      case 'suppliers':
        title = 'الموردين';
        content = _usersList(context,
            state.users.where(
                (u) => u.userType == 'مورد').toList());
      case 'engineers':
        title = 'المهندسين';
        content = _usersList(context,
            state.users.where(
                (u) => u.userType == 'مهندس').toList());
      case 'regularUsers':
        title = 'المستخدمين';
        content = _usersList(context,
            state.users.where(
                (u) => u.userType == 'مستخدم').toList());
      case 'activeUsers':
        title = 'الحسابات النشطة';
        content = _usersList(context,
            state.users.where(
                (u) => u.isActive).toList());
      case 'totalOrders':
        title = 'جميع الطلبات';
        content = _ordersList(state.orders);
      case 'completedOrders':
        title = 'الطلبات المكتملة';
        content = _ordersList(state.orders
            .where((o) =>
                o.status == OrderStatus.completed)
            .toList());
      case 'revenue':
        title = 'تفاصيل الإيرادات';
        content = _ordersList(state.orders
            .where((o) =>
                o.status == OrderStatus.completed &&
                o.productPrice != null)
            .toList());
      case 'pendingProducts':
        title = 'منتجات بانتظار الموافقة';
        content = _pendingProductsList(
            context, state.pendingProducts);
      case 'allProducts':
        title = 'جميع المنتجات';
        content = AdminAllProductsList(
            products: state.allProducts);
      default:
        return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AdminCubit>(),
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, controller) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.only(
                        bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                  Text(title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: [content],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _usersList(
      BuildContext context, List<UserEntity> users) {
    if (users.isEmpty) {
      return const Center(
          child: Text('لا يوجد مستخدمين',
              style: TextStyle(color: Colors.grey)));
    }
    return Column(
        children: users
            .map((u) => AdminUserCard(user: u))
            .toList());
  }

  Widget _ordersList(List<PartOrderModel> orders) {
    if (orders.isEmpty) {
      return const Center(
          child: Text('لا توجد طلبات',
              style: TextStyle(color: Colors.grey)));
    }
    return Column(
        children: orders
            .map((o) => _orderTile(o))
            .toList());
  }

  Widget _orderTile(PartOrderModel order) {
    Color statusColor;
    switch (order.status) {
      case OrderStatus.completed:
        statusColor = Colors.green;
      case OrderStatus.cancelled:
        statusColor = Colors.red;
      case OrderStatus.inProgress:
        statusColor = Colors.blue;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8, height: 40,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(order.partName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('#${order.orderNumber}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Text(
                  order.status.value,
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (order.productPrice != null)
                Text('${order.productPrice} ر.س',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pendingProductsList(
      BuildContext context, List<ProductEntity> products) {
    if (products.isEmpty) {
      return const Center(
          child: Text('لا توجد منتجات بانتظار الموافقة',
              style: TextStyle(color: Colors.grey)));
    }
    return Column(
        children: products
            .map((p) => _pendingProductTile(context, p))
            .toList());
  }

  Widget _pendingProductTile(
      BuildContext context, ProductEntity product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product.image.isNotEmpty
                ? Image.network(product.image,
                    width: 50, height: 50,
                    fit: BoxFit.cover)
                : Container(
                    width: 50, height: 50,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image,
                        color: Colors.grey)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(
                  '${product.brandName} • ${product.categoryName}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                Text('${product.price} ر.س',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle,
                color: Colors.green, size: 28),
            onPressed: () {
              context.read<AdminCubit>()
                  .approveProduct(product.id);
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.cancel,
                color: Colors.red, size: 28),
            onPressed: () {
              context.read<AdminCubit>()
                  .rejectProduct(product.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
