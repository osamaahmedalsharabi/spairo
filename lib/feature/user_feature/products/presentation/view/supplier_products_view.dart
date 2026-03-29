import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import '../../../../Authantication/presentation/cubit/auth_cubit.dart';
import '../../../../Authantication/presentation/cubit/auth_state.dart';
import '../view_model/products_cubit.dart';
import '../view_model/products_state.dart';
import 'widgets/product_grid_widget.dart';

class SupplierProductsView extends StatefulWidget {
  const SupplierProductsView({super.key});

  @override
  State<SupplierProductsView> createState() => _SupplierProductsViewState();
}

class _SupplierProductsViewState extends State<SupplierProductsView> {
  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessLogin) {
      context.read<ProductsCubit>().getSupplierProducts(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "منتجاتي",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading || state is ProductsInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is ProductsSuccess) {
            return ProductGridWidget(
              products: state.products,
              onProductTap: (product) {
                context
                    .pushNamed(AppRouteConst.productDetails, extra: product)
                    .then((_) => _fetchProducts()); // Refresh on return
              },
            );
          } else if (state is ProductsFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchProducts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      "إعادة المحاولة",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {
          context
              .pushNamed(AppRouteConst.addEditProduct)
              .then((_) => _fetchProducts()); // Refresh when coming back
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "إضافة منتج",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
