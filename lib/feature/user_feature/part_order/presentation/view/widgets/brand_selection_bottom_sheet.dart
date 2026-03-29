import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_brand_card.dart';

class BrandSelectionBottomSheet extends StatefulWidget {
  final List<BrandModel> brands;
  const BrandSelectionBottomSheet({super.key, required this.brands});

  @override
  State<BrandSelectionBottomSheet> createState() => _BrandSelectionState();
}

class _BrandSelectionState extends State<BrandSelectionBottomSheet> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.brands
        .where((b) => b.name.toLowerCase().contains(searchQuery.toLowerCase()))
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
              hintText: "ابحث عن شركة...",
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
                childAspectRatio: 0.8,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final brand = filtered[index];
                return HomeBrandCard(
                  brand: brand,
                  onTapOverride: () => Navigator.pop(context, brand),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
