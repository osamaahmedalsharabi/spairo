import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/category_model.dart';
import '../../../../../../Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';

class HomeCategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTapOverride;

  const HomeCategoryCard({super.key, required this.category, this.onTapOverride});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapOverride ?? () {
        context.pushNamed(
          AppRouteConst.filteredProductsView,
          extra: {
            'title': category.name,
            'filterType': 'category',
            'filterValue': category.name,
          },
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(
                child: category.image.isNotEmpty
                    ? Image.network(
                        category.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.settings_suggest,
                              color: AppColors.primary,
                            ),
                      )
                    : const Icon(
                        Icons.settings_suggest,
                        color: AppColors.primary,
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              category.name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
