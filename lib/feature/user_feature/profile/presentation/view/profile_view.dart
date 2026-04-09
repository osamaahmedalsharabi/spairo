import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/helpers/custom_snack_bar_widget.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';
import '../view_model/profile_cubit.dart';
import 'widgets/profile_body_widget.dart';

class ProfileView extends StatelessWidget {
  final UserEntity user;
  const ProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    cubit.init(user.name, user.email, user.phone, user.location);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('الملف الشخصي',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0, centerTitle: true,
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (ctx, s) => _handle(ctx, s),
        child: ProfileBodyWidget(user: user, cubit: cubit),
      ),
    );
  }

  void _handle(BuildContext c, ProfileState s) {
    if (s is ProfileSaved) {
      CustomSnackBarWidget.showSnackBar(
          c, 'تم حفظ التغييرات بنجاح', Colors.green);
    } else if (s is ProfileError) {
      CustomSnackBarWidget.showSnackBar(
          c, s.message, Colors.red);
    }
  }
}
