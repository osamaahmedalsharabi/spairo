import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/helpers/custom_snack_bar_widget.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/Widgets/CustomButton.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/get_user_orders_cubit.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  const LoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailureLogin) {
          CustomSnackBarWidget.showSnackBar(context, state.message, Colors.red);
        } else if (state is AuthSuccessLogin) {
          CustomSnackBarWidget.showSnackBar(
            context,
            "تم تسجيل الدخول بنجاح",
            Colors.green,
          );
          context.read<GetUserOrdersCubit>().getUserOrders();
          context.go("/${AppRouteConst.userHome}");
        }
      },
      builder: (context, state) {
        return CustomButton(text: "تسجيل الدخول", onTap: onTap);
      },
    );
  }
}
