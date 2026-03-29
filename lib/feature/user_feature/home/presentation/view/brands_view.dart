import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_brand_card.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_search_section.dart';

class BrandsView extends StatelessWidget {
  const BrandsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العلامات التجارية'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            HomeSearchSection(),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount:
                      (GoRouterState.of(context).extra as List<BrandModel>)
                          .length,
                  itemBuilder: (context, index) {
                    final brands =
                        GoRouterState.of(context).extra as List<BrandModel>;
                    return HomeBrandCard(brand: brands[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
