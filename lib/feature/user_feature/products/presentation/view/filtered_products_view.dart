import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../view_model/filtered_products_cubit/filtered_products_cubit.dart';
import '../view_model/filtered_products_cubit/filtered_products_state.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view/widgets/product_card_widget.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_search_section.dart';

class FilteredProductsView extends StatelessWidget {
  final String title;
  final String? excludeProductId;

  const FilteredProductsView({
    super.key, 
    required this.title,
    this.excludeProductId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const HomeSearchSection(),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<FilteredProductsCubit, FilteredProductsState>(
                builder: (context, state) {
                  if (state is FilteredProductsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  } else if (state is FilteredProductsSuccess) {
                    final displayProducts = excludeProductId != null 
                        ? state.products.where((p) => p.id != excludeProductId).toList()
                        : state.products;

                    if (displayProducts.isEmpty) {
                      return const Center(child: Text('لا توجد منتجات'));
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, 
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: displayProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCardWidget(
                          product: displayProducts[index],
                          onTap: () {
                            context.pushNamed(
                              AppRouteConst.productDetails,
                              extra: state.products[index],
                            );
                          },
                        );
                      },
                    );
                  } else if (state is FilteredProductsFailure) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
