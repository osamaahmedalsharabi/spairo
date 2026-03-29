import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/category_model.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_category_card.dart';

class CategorySelectionBottomSheet extends StatefulWidget {
  final List<CategoryModel> categories;
  const CategorySelectionBottomSheet({super.key, required this.categories});

  @override
  State<CategorySelectionBottomSheet> createState() =>
      _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelectionBottomSheet> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.categories
        .where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "ابحث عن نوع القطعة...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (val) => setState(() => searchQuery = val),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final category = filtered[index];
                return HomeCategoryCard(
                  category: category,
                  onTapOverride: () =>
                      Navigator.pop(context, category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
