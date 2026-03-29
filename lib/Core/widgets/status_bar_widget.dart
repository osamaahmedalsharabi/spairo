import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class StatusBarWidget extends StatelessWidget {
  final Widget child;
  const StatusBarWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.background.withAlpha(80),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: child,
    );
  }
}
