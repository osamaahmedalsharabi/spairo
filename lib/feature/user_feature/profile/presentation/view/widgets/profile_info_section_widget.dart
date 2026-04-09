import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'profile_info_field_widget.dart';

class ProfileInfoSectionWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const ProfileInfoSectionWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المعلومات الشخصيه',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ProfileInfoFieldWidget(controller: nameController, hint: 'الاسم'),
        ProfileInfoFieldWidget(
          controller: emailController,
          hint: 'البريد الإلكتروني',
        ),
        ProfileInfoFieldWidget(
          controller: phoneController,
          hint: 'رقم الهاتف',
          keyboardType: TextInputType.phone,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
          ],
        ),
      ],
    );
  }
}
