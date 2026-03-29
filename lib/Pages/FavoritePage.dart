// FavoritesPage.dart
import 'package:flutter/material.dart';
import '../Core/Theme/app_colors.dart';
import '../Pages/PartsDetailsPage.dart';

class FavoritesPage extends StatelessWidget {
  final List<Map<String, String>> favorites;

  const FavoritesPage({Key? key, required this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, "/home");
          }, icon: Icon(Icons.arrow_forward))
        ],
        title: const Text("المفضلة"),
        centerTitle: true,
        backgroundColor: AppColors.backgroundLight,
      ),
      body: Container(
        color: AppColors.backgroundLight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(
                        name: product["name"]!,
                        image: product["image"]!,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Main Row with Text and Image
                      Row(
                        children: [
                          // Text Section (left) - vertically centered
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Text(
                                      product["name"] ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      product["company"] ?? "Toyota",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const SizedBox(height: 4),
                                    Text(
                                      product["model"] ?? "2023 - 2022",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Image Section (Right)
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: Image.asset(
                                  product["image"]!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Favorite icon on top of image
                              Positioned(
                                top: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Store name top-left
                      Positioned(
                        top: 8,
                        left: 12,
                        child: Container(
                          width: 70,
                          height: 70,
                          child: Text(
                            "Sadeq Alryani Store",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
