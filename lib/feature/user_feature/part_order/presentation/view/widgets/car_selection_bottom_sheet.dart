import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';

class CarSelectionBottomSheet extends StatefulWidget {
  final List<BrandModel> cars;
  const CarSelectionBottomSheet({super.key, required this.cars});

  @override
  State<CarSelectionBottomSheet> createState() => _CarSelectionState();
}

class _CarSelectionState extends State<CarSelectionBottomSheet> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.cars
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
              hintText: "ابحث عن سيارة...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (val) => setState(() => searchQuery = val),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final car = filtered[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(80),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      car.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text(car.name),
                    onTap: () => Navigator.pop(context, car),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
