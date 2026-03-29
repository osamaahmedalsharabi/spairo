import 'package:flutter/material.dart';
import '../Core/Theme/app_colors.dart';

class FavoriteProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onFavorite;

  const FavoriteProductCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 12,
        color: AppColors.background,
        child: Container(
          width: 190,
          decoration: BoxDecoration(
            color: Color(0xFFFFF6EB),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Favorite icon
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: onFavorite,
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
              ),

              // Circular image
              ClipOval(
                child: Image.asset(
                  imagePath,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
