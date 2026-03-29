import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/helpers/custom_snack_bar_widget.dart';
import '../../domain/entities/user_entity.dart';
import '../../Widgets/Auth_Title.dart';
import '../cubit/auth_cubit.dart';
import 'register_form.dart';
import 'register_button.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});
  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _k = GlobalKey<FormState>();
  final _n = TextEditingController(),
      _e = TextEditingController(),
      _ph = TextEditingController(),
      _p = TextEditingController(),
      _cp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _k,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const AuthHeaderWidget(title: "حساب جديد"),
          const SizedBox(height: 20),
          RegisterForm(
            name: _n,
            email: _e,
            phone: _ph,
            pass: _p,
            confirmPass: _cp,
          ),
          const SizedBox(height: 30),
          RegisterButton(
            onTap: () {
              if (!_k.currentState!.validate()) return;
              if (_p.text != _cp.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("كلمات المرور غير متطابقة")),
                );
                return;
              }
              final cubit = context.read<AuthCubit>();
              if ((cubit.selectedUserType == "مورد") &&
                  cubit.selectedImage == null) {
                CustomSnackBarWidget.showSnackBar(
                  context,
                  "يجب إرفاق الصورة",
                  Colors.red,
                );
                return;
              }
              cubit.register(
                UserEntity(
                  id: '',
                  name: _n.text,
                  email: _e.text,
                  phone: _ph.text,
                  userType: cubit.selectedUserType,
                ),
                _p.text,
                cubit.selectedImage,
              );
            },
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "تمتلك حساب بالفعل ؟ ",
                style: TextStyle(fontSize: 13),
              ),
              TextButton(
                onPressed: () => context.pop(context),
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    color: Color(0xffFCA042),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
