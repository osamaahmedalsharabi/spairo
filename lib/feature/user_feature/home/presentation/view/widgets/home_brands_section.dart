import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brands/get_brands_cubit.dart';
import 'home_section_header.dart';
import 'home_brand_card.dart';

class HomeBrandsSection extends StatelessWidget {
  const HomeBrandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBrandsCubit, GetBrandsState>(
      builder: (context, state) {
        if (state is GetBrandsSuccess) {
          return Column(
            children: [
              HomeSectionHeader(
                title: 'العلامات التجارية',
                onViewAllPressed: () {
                  GoRouter.of(
                    context,
                  ).push('/${AppRouteConst.brandsView}', extra: state.brands);
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.brands.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return HomeBrandCard(brand: state.brands[index]);
                  },
                ),
              ),
            ],
          );
        } else if (state is GetBrandsFailure) {
          return Center(child: Text(state.message));
        } else {
          return Column(
            children: [
              HomeSectionHeader(
                title: 'العلامات التجارية',
                onViewAllPressed: () {},
              ),
              const SizedBox(height: 12),
              Skeletonizer(
                enabled: true,
                child: SizedBox(
                  height: 120,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return HomeBrandCard(
                        brand: BrandModel(
                          id: '0',
                          name: 'الاسم هنا',
                          image: '', // empty image, handled in the card
                        ),
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
