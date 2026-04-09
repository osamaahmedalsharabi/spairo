import 'package:flutter/material.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';
import '../../view_model/profile_cubit.dart';
import 'profile_info_section_widget.dart';
import 'profile_password_section_widget.dart';
import 'profile_save_section_widget.dart';
import 'profile_location_section_widget.dart';
import 'profile_map_picker_view.dart';

class ProfileBodyWidget extends StatelessWidget {
  final UserEntity user;
  final ProfileCubit cubit;
  const ProfileBodyWidget({
    super.key, required this.user, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(children: [
        ProfileInfoSectionWidget(
          nameController: cubit.nameController,
          emailController: cubit.emailController,
          phoneController: cubit.phoneController),
        if (user.userType == 'مهندس') ...[
          const SizedBox(height: 20),
          _location(context)],
        const SizedBox(height: 24),
        ProfilePasswordSectionWidget(
          oldPassController: cubit.oldPassController,
          newPassController: cubit.newPassController,
          confirmPassController: cubit.confirmPassController),
        const SizedBox(height: 40),
        ProfileSaveSectionWidget(cubit: cubit, user: user),
        const SizedBox(height: 24),
      ]),
    );
  }

  Widget _location(BuildContext ctx) {
    return StatefulBuilder(builder: (c, set) {
      return ProfileLocationSectionWidget(
        currentLocation: cubit.location,
        onTapPickLocation: () async {
          final r = await Navigator.push<String>(c,
            MaterialPageRoute(builder: (_) =>
              ProfileMapPickerView(initialLocation: cubit.location)));
          if (r != null) { cubit.updateLocation(r); set(() {}); }
        });
    });
  }
}
