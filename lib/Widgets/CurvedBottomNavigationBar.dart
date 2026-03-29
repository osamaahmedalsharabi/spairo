import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class CurvedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;
  final VoidCallback onFabTapped;

  const CurvedBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.onFabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Beige Background Circle behind the notch
          Positioned(
            top: 5,
            child: Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Colors.transparent, // Light beige color from design
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Custom Painted Orange Curved Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 75), // Bar height
              painter: BottomNavCurvePainter(),
            ),
          ),

          // Navigation Items Row
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // RTL Layout items (right to left):
                // Index 0: الرئيسية (Home)
                // Index 1: الخبراء (Experts)
                // Middle Gap
                // Index 2: طلباتي (My Orders)
                // Index 3: المفضلة (Favorites)
                _buildNavItem(Icons.home_outlined, Icons.home, "الرئيسية", 0),
                _buildNavItem(
                  Icons.engineering_outlined,
                  Icons.engineering,
                  "الخبراء",
                  1,
                ),
                const SizedBox(width: 70), // Space for central FAB
                _buildNavItem(
                  Icons.assignment_outlined,
                  Icons.assignment,
                  "طلباتي",
                  2,
                ),
                _buildNavItem(
                  Icons.favorite_outline,
                  Icons.favorite,
                  "المفضلة",
                  3,
                ),
              ],
            ),
          ),

          // Central Floating Action Button
          Positioned(
            top: 5,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onFabTapped,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primary],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 38),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData outlineIcon,
    IconData filledIcon,
    String label,
    int index,
  ) {
    final isSelected = currentIndex == index;
    final icon = isSelected ? filledIcon : outlineIcon;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onItemSelected(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF334A52), // Dark Slate
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF334A52),
                fontWeight: FontWeight.w500,
                fontSize: isSelected ? 15 : 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFEAD45), // Top light orange
          AppColors.primary, // Bottom dark orange
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path path = Path();
    double cornerRadius = 32.0;

    double notchRadius = 45.0;
    double center = size.width / 2;

    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Line to the start of the notch
    path.lineTo(center - notchRadius - 12, 0);

    // Draw the notch
    path.quadraticBezierTo(center - notchRadius, 0, center - notchRadius, 10);
    path.arcToPoint(
      Offset(center + notchRadius, 10),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.quadraticBezierTo(
      center + notchRadius,
      0,
      center + notchRadius + 12,
      0,
    );

    // Line to top right
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Line to bottom corners
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Outer shadow
    canvas.drawShadow(path, Colors.black.withOpacity(0.4), 12.0, true);

    // Fill the shape
    canvas.drawPath(path, paint);

    // Inner top border (emboss effect)
    Paint strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path strokePath = Path();
    strokePath.moveTo(0, cornerRadius);
    strokePath.quadraticBezierTo(0, 0, cornerRadius, 0);
    strokePath.lineTo(center - notchRadius - 12, 0);
    strokePath.quadraticBezierTo(
      center - notchRadius,
      0,
      center - notchRadius,
      10,
    );
    strokePath.arcToPoint(
      Offset(center + notchRadius, 10),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    strokePath.quadraticBezierTo(
      center + notchRadius,
      0,
      center + notchRadius + 12,
      0,
    );
    strokePath.lineTo(size.width - cornerRadius, 0);
    strokePath.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    canvas.drawPath(strokePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
