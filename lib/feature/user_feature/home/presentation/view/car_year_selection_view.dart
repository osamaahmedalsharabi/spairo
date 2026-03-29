import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_search_section.dart';

class CarYearSelectionView extends StatelessWidget {
  final String brandName;
  final String carName;

  const CarYearSelectionView({
    super.key,
    required this.brandName,
    required this.carName,
  });

  @override
  Widget build(BuildContext context) {
    // Generate years dynamically (from 1990 to Current Year)
    final currentYear = DateTime.now().year + 1; // Future year buffer
    final List<String> years = List.generate(
      currentYear - 1989,
      (index) => (currentYear - index).toString(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر الموديل (سنة الصنع)'),
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
                  "$brandName - $carName",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.2,
                ),
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final year = years[index];
                  return InkWell(
                    onTap: () {
                      context.pushNamed(
                        AppRouteConst.filterCategorySelectionView,
                        extra: {
                          'brandName': brandName,
                          'carName': carName,
                          'year': year,
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white.withAlpha(200),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withAlpha(50)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        year,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
