import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/Core/helpers/custom_snack_bar_widget.dart';
import 'presentation/cubit/auth_cubit.dart';
import 'presentation/cubit/auth_state.dart';
import 'presentation/widgets/register_body.dart';
import '../../Core/Theme/app_colors.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                title: const Text(
                  "إنشاء حساب",
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
              ),
              backgroundColor: AppColors.background,
              resizeToAvoidBottomInset: true,
              body: const SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: RegisterBody(),
                ),
              ),
            ),
            if (state is AuthLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xffFCA042)),
                ),
              ),
          ],
        );
      },
    );
  }
}
