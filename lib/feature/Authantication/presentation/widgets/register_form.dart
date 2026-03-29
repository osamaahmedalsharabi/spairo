import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparioapp/Widgets/UserDropDownType.dart';
import '../../Widgets/Auth_TextField.dart';
import 'image_picker_widget.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController pass;
  final TextEditingController confirmPass;

  const RegisterForm({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.pass,
    required this.confirmPass,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "أختيار نوع تسجيل الدخول",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 15),
        const UserTypeDropdown(),
        const SizedBox(height: 10),
        AuthTextField(
          controller: name,
          hint: "الاسم الكامل",
          icon: const Icon(Icons.person_outline, color: Colors.grey),
          keyboardType: TextInputType.text,
          validator: (v) => v!.isEmpty ? "الاسم الكامل مطلوب" : null,
        ),
        const SizedBox(height: 10),
        AuthTextField(
          controller: email,
          hint: "البريد الإلكتروني",
          icon: const Icon(Icons.email_outlined, color: Colors.grey),
          keyboardType: TextInputType.emailAddress,
          validator: (v) => v!.isEmpty
              ? "البريد الإلكتروني مطلوب"
              : (v.contains('@') ? null : "بريد إلكتروني غير صالح"),
        ),
        const SizedBox(height: 10),
        AuthTextField(
          controller: phone,
          hint: "رقم الهاتف",
          icon: const Icon(Icons.phone_outlined, color: Colors.grey),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
          ],
          validator: (v) => validatePhoneNumber(v, context: context),
        ),
        const SizedBox(height: 10),
        AuthTextField(
          controller: pass,
          hint: "كلمة المرور",
          isPassword: true,
          icon: const Icon(Icons.lock_outline, color: Colors.grey),
          keyboardType: TextInputType.text,
          validator: (v) => v!.length < 6 ? "كلمة المرور قصيرة جداً" : null,
        ),
        const SizedBox(height: 10),
        AuthTextField(
          controller: confirmPass,
          hint: "تأكيد كلمة المرور",
          isPassword: true,
          icon: const Icon(Icons.lock_outline, color: Colors.grey),
          keyboardType: TextInputType.text,
          validator: (v) => v!.isEmpty ? "تأكيد كلمة المرور مطلوب" : null,
        ),
        const SizedBox(height: 10),
        const ImagePickerWidget(),
      ],
    );
  }
}

String? validatePhoneNumber(String? value, {required BuildContext context}) {
  final raw = value?.trim() ?? '';
  if (raw.isEmpty) {
    return "رقم الهاتف مطلوب";
  }

  final normalized = raw.replaceAll(RegExp(r'[\s-]'), '');

  final phoneRegex = RegExp(r'^(77|78|71|73|70)\d{7}$');

  if (!phoneRegex.hasMatch(normalized)) {
    return "رقم الهاتف يجب أن يتكون من 9 أرقام ويبدأ بـ 77، 78، 71، 73، أو 70";
  }
  return null;
}
