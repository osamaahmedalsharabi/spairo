import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brand_cars/get_brand_cars_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_search_section.dart';

class BrandCarsView extends StatelessWidget {
  const BrandCarsView({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = GoRouterState.of(context).extra as BrandModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(brand.name),
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
              child: BlocBuilder<GetBrandCarsCubit, GetBrandCarsState>(
                builder: (context, state) {
                  if (state is GetBrandCarsSuccess) {
                    if (state.cars.isEmpty) {
                      return const Center(
                        child: Text("لا توجد سيارات لهذه العلامة التجارية"),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.cars.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final car = state.cars[index];
                        return InkWell(
                          onTap: () {
                            context.pushNamed(
                              AppRouteConst.carYearSelectionView,
                              extra: {
                                'brandName': brand.name,
                                'carName': car.name,
                              },
                            );
                          },
                          child: Card(
                            elevation: 0,
                            color: AppColors.white.withAlpha(80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: AppColors.white,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                car.image.isNotEmpty
                                    ? Image.network(
                                        car.image,
                                        width: 200,
                                        height: 200,
                                      )
                                    : const Icon(Icons.directions_car),
                                SizedBox(height: 8),
                                Text(
                                  car.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is GetBrandCarsFailure) {
                    return Center(child: Text(state.message));
                  } else {
                    return Skeletonizer(
                      enabled: true,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 8,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'اسم السيارة هنا alkdfj asdfaslfk ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
