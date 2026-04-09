import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'profile_password_field_widget.dart';

class ProfilePasswordSectionWidget extends StatelessWidget {
  final TextEditingController oldPassController;
  final TextEditingController newPassController;
  final TextEditingController confirmPassController;

  const ProfilePasswordSectionWidget({
    super.key,
    required this.oldPassController,
    required this.newPassController,
    required this.confirmPassController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تغيير كلمة المرور',
          style: TextStyle(
           fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ProfilePasswordFieldWidget(
          controller: oldPassController,
          hint: 'كلمة المرور الحالي',
        ),
        ProfilePasswordFieldWidget(
          controller: newPassController,
          hint: 'كلمة المرور الجديده',
        ),
        ProfilePasswordFieldWidget(
          controller: confirmPassController,
          hint: 'تأكيد كلمة المرور الجديده',
        ),
      ],
    );
  }
}
