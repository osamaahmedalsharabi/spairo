import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  String? location;
  ProfileCubit(this._repo) : super(ProfileInitial());

  void init(String name, String email, String phone, String? loc) {
    nameController.text = name;
    emailController.text = email;
    phoneController.text = phone;
    location = loc;
  }

  void updateLocation(String loc) => location = loc;

  Future<void> saveChanges(String uid, String oN, String oE,
      String oP, String? oL) async {
    emit(ProfileLoading());
    try {
      if (nameController.text != oN) await _repo.updateName(uid, nameController.text);
      if (emailController.text != oE) await _repo.updateEmail(uid, emailController.text);
      if (phoneController.text != oP) await _repo.updatePhone(uid, phoneController.text);
      if (location != oL && location != null) await _repo.updateLocation(uid, location!);
      if (oldPassController.text.isNotEmpty) {
        await _repo.changePassword(uid, oldPassController.text, newPassController.text);
      }
      oldPassController.clear();
      newPassController.clear();
      confirmPassController.clear();
      emit(ProfileSaved());
    } catch (e) { emit(ProfileError(e.toString())); }
  }

  @override
  Future<void> close() {
    for (final c in [nameController, emailController, phoneController,
      oldPassController, newPassController, confirmPassController]) c.dispose();
    return super.close();
  }
}
