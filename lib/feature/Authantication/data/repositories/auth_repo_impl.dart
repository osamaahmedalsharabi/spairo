import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../../../../Core/errors/firebase_error_helper.dart';
import '../../../../Core/di/injection_container.dart';
import '../../../../Core/services/fcm_service.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDS;
  final AuthLocalDataSource localDS;

  AuthRepoImpl(this.remoteDS, this.localDS);

  @override
  Future<Either<String, UserEntity>> login(
    String email,
    String pass,
    String userType,
  ) async {
    try {
      final user = await remoteDS.login(email, pass);
      await localDS.saveUser(user);
      // Update FCM Token after login
      await sl.get<FCMService>().updateUserTokenOnLogin();
      return Right(user);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, UserEntity>> register({
    required UserEntity user,
    required String password,
    File? commercialRegisterImage,
  }) async {
    try {
      final res = await remoteDS.register(
        user,
        password,
        commercialRegisterImage,
      );
      // Update FCM Token after registration
      await sl.get<FCMService>().updateUserTokenOnLogin();
      return Right(res);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, UserEntity>> getUserData(String uid) async {
    try {
      final user = await remoteDS.getUserData(uid);
      return Right(user);
    } catch (e) {
      return Left(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, UserEntity>> checkAuthStatus() async {
    try {
      final user = await localDS.getUser();
      if (user != null) {
        // Update FCM Token on auto-login
        sl.get<FCMService>().updateUserTokenOnLogin();
        return Right(user);
      }
      return const Left('لا يوجد مستخدم مسجل الدخول.');
    } catch (e) {
      return Left('حدث خطأ أثناء جلب بيانات المستخدم: $e');
    }
  }

  @override
  Future<void> logout() async {
    await sl.get<FCMService>().removeTokenOnLogout();
    await remoteDS.auth.signOut();
    await localDS.clearUser();
  }
}
