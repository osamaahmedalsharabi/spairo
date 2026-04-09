import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/helpers/custom_snack_bar_widget.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';
import '../../view_model/profile_cubit.dart';
import 'profile_save_button_widget.dart';

class ProfileSaveSectionWidget extends StatelessWidget {
  final ProfileCubit cubit;
  final UserEntity user;

  const ProfileSaveSectionWidget({
    super.key, required this.cubit, required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (ctx, state) => ProfileSaveButtonWidget(
        isLoading: state is ProfileLoading,
        onTap: () => _onSave(ctx),
      ),
    );
  }

  void _onSave(BuildContext ctx) {
    final c = cubit;
    if (c.oldPassController.text.isNotEmpty) {
      if (c.newPassController.text.length < 6) {
        _err(ctx, 'كلمة المرور يجب أن تكون 6 أحرف على الأقل');
        return;
      }
      if (c.newPassController.text !=
          c.confirmPassController.text) {
        _err(ctx, 'كلمات المرور غير متطابقة');
        return;
      }
    }
    c.saveChanges(user.id, user.name, user.email,
        user.phone, user.location);
  }

  void _err(BuildContext c, String m) =>
      CustomSnackBarWidget.showSnackBar(c, m, Colors.red);
}
