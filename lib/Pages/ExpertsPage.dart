import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class ExpertCardDesign extends StatelessWidget {
  const ExpertCardDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 140,
          margin: const EdgeInsets.only(top: 32),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background, // light beige
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= AVATAR (RIGHT SIDE) =================
              Column(
                children: [
                  Container(
                    width: 77,
                    height: 77,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFE0C2),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.orange,
                      size: 46,
                    ),
                  ),
                  const SizedBox(height: 8),
        
                ],
              ),
        
              const SizedBox(width: 12),
        
              /// ================= TEXT INFO =================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name
                    const Text(
                      "عبد الرحمن ياسين",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A3A3A),
                      ),
                    ),
        
                    const SizedBox(height: 4),
        
                    /// Category
                    const Text(
                      "ميكانيك سيارات",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
        
                    const SizedBox(height: 6),
        
                    /// Address
                    const Text(
                      "العنوان: باب اليمن، جامعة صنعاء القديمة",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6E6E6E),
                      ),
                    ),
        
                    const SizedBox(height: 8),
        
                    /// Phone
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(
                          Icons.phone,
                          size: 16,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "779419803",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3A3A3A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
