import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_categories/get_categories_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_search_section.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_category_card.dart';

class FilterCategorySelectionView extends StatelessWidget {
  final String brandName;
  final String carName;
  final String year;

  const FilterCategorySelectionView({
    super.key,
    required this.brandName,
    required this.carName,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر التصنيف'),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "$brandName - $carName - $year",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
                builder: (context, state) {
                  if (state is GetCategoriesSuccess) {
                    if (state.categories.isEmpty) {
                      return const Center(child: Text('لا توجد تصنيفات'));
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withAlpha(50),
                            ),
                          ),
                          child: HomeCategoryCard(
                            category: category,
                            onTapOverride: () {
                              context.pushNamed(
                                AppRouteConst.filteredProductsView,
                                extra: {
                                  'title': category.name,
                                  'filterType': 'multi',
                                  'carName': carName,
                                  'year': year,
                                  'categoryName': category.name,
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is GetCategoriesFailure) {
                    return Center(child: Text(state.message));
                  } else {
                    return Skeletonizer(
                      enabled: true,
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
