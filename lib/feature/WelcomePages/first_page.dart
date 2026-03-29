import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Core/Theme/app_colors.dart';
import '../../Widgets/CustomButton.dart';

class WelcomeFirstPage extends StatelessWidget {
  const WelcomeFirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 70),
          child: Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(313)),
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
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          InfoCardWidget(),

                          const SizedBox(height: 50),
                          CustomButton(
                            text: "متابعة",
                            onTap: () => context.push('/welcome2'),
                          ),

                          const SizedBox(height: 15),
                          CustomButton(
                            text: "تخطي",
                            onTap: () => context.go('/login'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// بطاقة تعريف سريعة
class InfoCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      elevation: 22,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset("assets/carspairo.png", height: 200),
            const SizedBox(height: 10),
            const Text(
              "Spairo هو التطبيق الأفضل لبيع وشراء قطع السيارات بكل سهولة.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
