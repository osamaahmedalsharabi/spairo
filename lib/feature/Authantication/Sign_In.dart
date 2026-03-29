import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'presentation/cubit/auth_cubit.dart';
import 'presentation/cubit/auth_state.dart';
import 'presentation/widgets/login_body.dart';
import '../../Core/Theme/app_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                  "تسجيل الدخول",
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              backgroundColor: AppColors.background,
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: const IntrinsicHeight(child: LoginBody()),
                      ),
                    );
                  },
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
