import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

import '../Pages/PartsDetailsPage.dart';

class DirectProductsListWidget extends StatelessWidget {
  const DirectProductsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {"name": "Toyota Brake Pads", "image": "assets/1.JPG"},
      {"name": "BMW Oil Filter", "image": "assets/1.JPG"},
      {"name": "Mercedes Air Filter", "image": "assets/1.JPG"},
    ];

    return Container(
      height: 260,
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            textAlign: TextAlign.right,
            "منتجات مباشرة    ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, i) {
                final p = products[i];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(
                          name: p["name"]!,
                          image: p["image"]!,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: AppColors.background,
                      margin: const EdgeInsets.only(right: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 10,
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: Align(
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    p["image"]!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding:
                                    const EdgeInsets.only(bottom: 6, right: 6),
                                child: Text(
                                  p["name"]!,
                                  textAlign: TextAlign.right,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
