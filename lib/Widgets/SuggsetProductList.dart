// SuggestedProductsListWidget.dart
import 'package:flutter/material.dart';
import '../Pages/PartsDetailsPage.dart';
import '../Core/Theme/app_colors.dart';

class SuggestedProductsListWidget extends StatelessWidget {
  final List<Map<String, String>> products;
  final List<Map<String, String>> favorites;
  final Function(Map<String, String>) onAddToFavorites;

  const SuggestedProductsListWidget({
    Key? key,
    required this.products,
    required this.favorites,
    required this.onAddToFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Container(
        color: AppColors.background,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, i) {
            final p = products[i];
            bool isFav = favorites.contains(p);

            return StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                  child: Container(
                    width: 180,
                    margin: const EdgeInsets.only(right: 14),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Card(
                            color: AppColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      p["image"]!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    p["name"]!,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isFav = !isFav;
                                if (isFav) onAddToFavorites(p);
                              });
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.grey[700],
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
