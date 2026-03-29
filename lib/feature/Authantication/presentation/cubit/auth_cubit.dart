import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/entities/user_entity.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo repo;
  String selectedUserType = 'مستخدم';
  File? selectedImage;

  AuthCubit(this.repo) : super(AuthInitial());

  void changeUserType(String type) {
    selectedUserType = type;
    emit(UserTypeChanged(type));
  }

  void imagePicked(File image) {
    selectedImage = image;
    emit(ImageSelected(image));
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final res = await repo.login(email, password, selectedUserType);
    res.fold(
      (err) => emit(AuthFailureLogin(err)),
      (user) => emit(AuthSuccessLogin(user)),
    );
  }

  Future<void> register(UserEntity user, String pass, File? img) async {
    emit(AuthLoading());
    final res = await repo.register(
      user: user,
      password: pass,
      commercialRegisterImage: img,
    );
    res.fold(
      (err) => emit(AuthFailureRegister(err)),
      (u) => emit(AuthSuccessRegister(u)),
    );
  }

  Future<void> checkAuthStatus() async {
    final res = await repo.checkAuthStatus();
    res.fold(
      (err) => emit(AuthInitial()),
      (user) => emit(AuthSuccessLogin(user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await repo.logout();
    emit(const AuthFailureLogin('تم تسجيل الخروج.'));
  }
}
