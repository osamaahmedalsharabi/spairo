import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/feature/Authantication/domain/repositories/auth_repo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeText;
  late Animation<Offset> _slideText;
  late Animation<Offset> _imageSlideUp;

  final String text = "Spairo";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _imageSlideUp = Tween<Offset>(
      begin: const Offset(0, 2.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeText = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0)),
    );

    _slideText = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0)),
        );

    // التحقق من حالة الدخول السابقة بعد 4 ثواني
    Future.delayed(const Duration(seconds: 4), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

      if (mounted) {
        if (isFirstTime) {
          await prefs.setBool('isFirstTime', false);
          context.go('/welcome1');
        } else {
          try {
            final authRepo = sl.get<AuthRepo>();
            // Timeout of 5 seconds to avoid freezing in release mode
            final authStatus = await authRepo
                .checkAuthStatus()
                .timeout(const Duration(seconds: 5));
            if (mounted) {
              authStatus.fold(
                (failure) => context.go('/login'),
                (user) => context.go('/userHome'),
              );
            }
          } catch (_) {
            // On timeout or any error, go to login safely
            if (mounted) context.go('/login');
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSlightlyDarker1,

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ▓▓ دائرة خارجية مع الأنيميشن
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const SweepGradient(
                  colors: [
                    Color(0xFFEF6C00),
                    Color(0xFFEF6C00),
                    Color(0xFFEF6C00),
                    Colors.black,
                    Color(0xFFEF6C00),
                    Color(0xFFEF6C00),
                    Colors.black,
                    Color(0xFFEF6C00),
                  ],
                ),
                border: Border.all(color: Colors.orangeAccent, width: 4),
              ),

              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundSlightlyDarker1,
                ),
                child: ClipOval(
                  child: Container(
                    color: Colors.orange.shade100,
                    child: SlideTransition(
                      position: _imageSlideUp,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          backgroundColor: AppColors.backgroundSlightlyDarker1,
                          radius: 100,
                          backgroundImage: const AssetImage(
                            "assets/logo-spairo.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // نص Spairo المتحرك
            FadeTransition(
              opacity: _fadeText,
              child: SlideTransition(
                position: _slideText,
                child: Text(
                  "Spairo",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
