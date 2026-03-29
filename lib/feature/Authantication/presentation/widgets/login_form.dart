import 'package:flutter/material.dart';
import '../../Widgets/Auth_TextField.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;

  const LoginForm({super.key, required this.emailCtrl, required this.passCtrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   "أختيار نوع تسجيل الدخول",
        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        // ),
        // const SizedBox(height: 5),
        // const UserTypeDropdown(),
        const SizedBox(height: 35),
        AuthTextField(
          controller: emailCtrl,
          hint: "البريد الإلكتروني",
          icon: const Icon(Icons.email_outlined, color: Colors.grey),
          keyboardType: TextInputType.emailAddress,
          validator: (v) => v!.isEmpty
              ? "البريد الإلكتروني مطلوب"
              : (v.contains('@') ? null : "بريد إلكتروني غير صالح"),
        ),
        const SizedBox(height: 15),
        AuthTextField(
          controller: passCtrl,
          hint: "كلمة المرور",
          isPassword: true,
          icon: const Icon(Icons.lock_outline, color: Colors.grey),
          keyboardType: TextInputType.text,
          validator: (v) => v!.isEmpty ? "كلمة المرور مطلوبة" : null,
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "نسيت كلمة المرور ؟",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
