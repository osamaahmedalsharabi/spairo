import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sparioapp/feature/user_feature/products/domain/entities/product_entity.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view_model/products_cubit.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view_model/products_state.dart';
import 'home_section_header.dart';
import 'home_recommendation_card.dart';

class HomeRecommendationsSection extends StatelessWidget {
  const HomeRecommendationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return Skeletonizer(
            child: Column(
              children: [
                HomeSectionHeader(
                  title: 'مقترحات قد تعجبك',
                  onViewAllPressed: () {
                    context.pushNamed(
                      AppRouteConst.filteredProductsView,
                      extra: {
                        'title': 'جميع المنتجات',
                        'filterType': 'all',
                        'filterValue': 'all',
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 185,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return const HomeRecommendationCard(
                        product: ProductEntity(
                          id: '0',
                          name: 'الاسم هنا',
                          image: '',
                          price: 0,
                          brandName: "hiadslf",
                          carName: " adslfkja",
                          categoryName: "a;lsdkjf",
                          condition: "lakjdsf",
                          description: "adslfkja",
                          supplierId: "adslfkja",
                          modelYear: "2020",
                          quantity: 0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProductsSuccess) {
          return Column(
            children: [
              HomeSectionHeader(
                title: 'مقترحات قد تعجبك',
                onViewAllPressed: () {
                  context.pushNamed(
                    AppRouteConst.filteredProductsView,
                    extra: {
                      'title': 'جميع المنتجات',
                      'filterType': 'all',
                      'filterValue': 'all',
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 185,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.products.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return HomeRecommendationCard(
                      product: state.products[index],
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is ProductsFailure) {
          return Center(child: Text(state.message));
        } else {
          return Skeletonizer(
            child: Column(
              children: [
                HomeSectionHeader(
                  title: 'مقترحات قد تعجبك',
                  onViewAllPressed: () {
                    context.pushNamed(
                      AppRouteConst.filteredProductsView,
                      extra: {
                        'title': 'جميع المنتجات',
                        'filterType': 'all',
                        'filterValue': 'all',
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 185,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return const HomeRecommendationCard(
                        product: ProductEntity(
                          id: '0',
                          name: 'الاسم هنا',
                          image: '',
                          price: 0,
                          brandName: "hiadslf",
                          carName: " adslfkja",
                          categoryName: "a;lsdkjf",
                          condition: "lakjdsf",
                          description: "adslfkja",
                          supplierId: "adslfkja",
                          modelYear: "2020",
                          quantity: 0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
