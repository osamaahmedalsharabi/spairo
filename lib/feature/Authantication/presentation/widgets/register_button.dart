import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/helpers/custom_snack_bar_widget.dart';
import 'package:sparioapp/Widgets/CustomButton.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onTap;
  const RegisterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailureRegister) {
          CustomSnackBarWidget.showSnackBar(context, state.message, Colors.red);
        } else if (state is AuthSuccessRegister) {
          CustomSnackBarWidget.showSnackBar(
            context,
            "تم انشاء حساب بنجاح",
            Colors.green,
          );
          context.go("/login");
        }
      },
      builder: (context, state) {
        return CustomButton(text: "إنشاء حساب", onTap: onTap);
      },
    );
  }
}
