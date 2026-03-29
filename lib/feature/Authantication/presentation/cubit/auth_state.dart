import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccessLogin extends AuthState {
  final UserEntity user;
  const AuthSuccessLogin(this.user);
  @override
  List<Object?> get props => [user];
}



class AuthSuccessRegister extends AuthState {
  final UserEntity user;
  const AuthSuccessRegister(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthFailureLogin extends AuthState {
  final String message;
  const AuthFailureLogin(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthFailureRegister extends AuthState {
  final String message;
  const AuthFailureRegister(this.message);
  @override
  List<Object?> get props => [message];
}

class UserTypeChanged extends AuthState {
  final String userType;
  const UserTypeChanged(this.userType);
  @override
  List<Object?> get props => [userType];
}

class ImageSelected extends AuthState {
  final File image;
  const ImageSelected(this.image);
  @override
  List<Object?> get props => [image];
}
