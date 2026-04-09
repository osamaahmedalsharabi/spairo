import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view_model/filtered_products_cubit/filtered_products_cubit.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view_model/filtered_products_cubit/filtered_products_state.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view/widgets/product_card_widget.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_search_section.dart';

class PriceComparisonView extends StatelessWidget {
  final String categoryName;
  final String? excludeProductId;

  const PriceComparisonView({
    super.key,
    required this.categoryName,
    this.excludeProductId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مقارنة الأسعار'),
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
                    // Sort locally by lowest price to highest and exclude the current product
                    final filteredList = state.products.where((p) => p.id != excludeProductId).toList();
                    
                    if (filteredList.isEmpty) {
                      return const Center(child: Text('لا توجد منتجات مشابهة للمقارنة'));
                    }

                    final sortedProducts = List.of(filteredList)
                      ..sort((a, b) => a.price.compareTo(b.price));

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, 
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: sortedProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCardWidget(
                          product: sortedProducts[index],
                          onTap: () {
                            context.pushNamed(
                              AppRouteConst.productDetails,
                              extra: sortedProducts[index],
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
