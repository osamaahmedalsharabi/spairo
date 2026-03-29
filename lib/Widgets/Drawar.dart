import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Drawer(
        backgroundColor: AppColors.background,
        child: Directionality(
          textDirection: TextDirection.rtl, // Arabic RTL
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color:AppColors.background),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      "حسابي",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.account_circle_sharp,
                          size: 50,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              "صادق الرياني",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Sadeqalryani127@gmail.com",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              drawerItem(Icons.account_circle_sharp, "الملف الشخصي", () => Navigator.pushNamed(context, "/profile")),
              drawerItem(Icons.favorite, "المفضلة", () => Navigator.pushNamed(context, "/favorites")),
              drawerItem(Icons.settings, "الإعدادات", () {}),
              drawerItem(Icons.exit_to_app, "تسجيل الخروج", () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
      title: Row(
        children: [
          Icon(icon, color: Colors.black87),
          const SizedBox(width: 10), // small space between icon and text
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
