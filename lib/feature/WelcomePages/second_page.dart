import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Core/Theme/app_colors.dart';
import '../../Widgets/CustomButton.dart';

class WelcomeLastPage extends StatelessWidget {
  const WelcomeLastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 70),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/carspairo.png"),
              opacity: 0.1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // شعار التطبيق
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "assets/logo-spairo.png",
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Spairo",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),

                // بطاقة المعلومات
                InfoCardWidget(
                  infoList: [
                    ". منصة متكاملة لبيع وشراء قطع السيارات بسهولة وسرعة",
                    ". تصفح آلاف المنتجات وتواصل مباشرة مع البائعين",
                    ". تقدم أفضل العروض والأسعار لجميع أنواع السيارات",
                    ". سهولة الدفع والتوصيل إلى أي مكان تختاره",
                    ". واجهة بسيطة وسريعة تجعل تجربتك ممتعة ومريحة",
                  ],
                ),

                const SizedBox(height: 40),
                CustomButton(
                  text: "ابدأ الآن",
                  onTap: () => context.go('/login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// بطاقة تعريف سريعة مع قائمة معلومات
class InfoCardWidget extends StatelessWidget {
  final List<String> infoList;
  const InfoCardWidget({super.key, required this.infoList});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        color: AppColors.background.withOpacity(0.9),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: infoList
                .map(
                  (text) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
