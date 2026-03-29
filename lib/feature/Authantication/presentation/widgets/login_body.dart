import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/get_user_orders_cubit.dart';
import '../../Widgets/Auth_Title.dart';
import '../cubit/auth_cubit.dart';
import 'login_form.dart';
import 'login_button.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});
  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _k = GlobalKey<FormState>();
  final _e = TextEditingController(), _p = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _k,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const AuthHeaderWidget(title: "تسجيل الدخول"),
          const SizedBox(height: 20),
          LoginForm(emailCtrl: _e, passCtrl: _p),
          const SizedBox(height: 30),
          LoginButton(
            onTap: () {
              if (_k.currentState!.validate()) {
                context.read<AuthCubit>().login(_e.text, _p.text);
              }
            },
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () async {
              context.pushNamed(AppRouteConst.userHome);
              await context.read<GetUserOrdersCubit>().getUserOrders();
            },
            child: const Text(
              "الاستمرار كزائر",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("ليس لديك حساب ؟ ", style: TextStyle(fontSize: 13)),
              TextButton(
                onPressed: () => context.push("/register"),
                child: const Text(
                  "إنشاء حساب",
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
