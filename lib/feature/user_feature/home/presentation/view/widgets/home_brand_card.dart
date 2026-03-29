import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';

class HomeBrandCard extends StatelessWidget {
  final BrandModel brand;
  final VoidCallback? onTapOverride;

  const HomeBrandCard({super.key, required this.brand, this.onTapOverride});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTapOverride ??
          () {
            context.pushNamed(AppRouteConst.brandCarsView, extra: brand);
          },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.white.withAlpha(80),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: brand.image.isNotEmpty
                  ? Image.network(
                      brand.image,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(Icons.image, color: Colors.grey, size: 40),
            ),
            SizedBox(
              width: 100,
              child: Text(
                brand.name,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
