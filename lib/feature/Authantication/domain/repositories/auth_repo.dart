import 'dart:io';
import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<String, UserEntity>> login(
    String email,
    String password,
    String userType,
  );

  Future<Either<String, UserEntity>> register({
    required UserEntity user,
    required String password,
    File? commercialRegisterImage,
  });

  Future<Either<String, UserEntity>> getUserData(String uid);
  Future<Either<String, UserEntity>> checkAuthStatus();
  Future<void> logout();
}
