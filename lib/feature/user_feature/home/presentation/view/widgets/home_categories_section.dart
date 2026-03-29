import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/category_model.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_categories/get_categories_cubit.dart';
import 'home_section_header.dart';
import 'home_category_card.dart';

class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
      builder: (context, state) {
        if (state is GetCategoriesSuccess) {
          return Column(
            children: [
              HomeSectionHeader(
                title: 'تصنيفات قطع الغيار',
                onViewAllPressed: () {
                  GoRouter.of(context).pushNamed(
                    AppRouteConst.categoriesView,
                    extra: state.categories,
                  );
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return HomeCategoryCard(category: state.categories[index]);
                  },
                ),
              ),
            ],
          );
        } else if (state is GetCategoriesFailure) {
          return Center(child: Text(state.message));
        } else {
          return Column(
            children: [
              HomeSectionHeader(
                title: 'تصنيفات قطع الغيار',
                onViewAllPressed: () {},
              ),
              const SizedBox(height: 12),
              Skeletonizer(
                enabled: true,
                child: SizedBox(
                  height: 110,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return HomeCategoryCard(
                        category: CategoryModel(name: 'تصنيف هنا', image: ''),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
