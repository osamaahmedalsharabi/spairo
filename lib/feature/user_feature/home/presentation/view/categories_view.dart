import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/category_model.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_category_card.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_search_section.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get categories from router state extra
    final List<CategoryModel> categories =
        GoRouterState.of(context).extra as List<CategoryModel>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('تصنيفات قطع الغيار'),
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
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Matches Brands setup
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return HomeCategoryCard(category: categories[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
