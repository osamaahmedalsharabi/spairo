import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final String? commercialRegisterImage;
  final bool isActive;
  final String? fcmToken;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.commercialRegisterImage,
    this.isActive = false,
    this.fcmToken,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    userType,
    commercialRegisterImage,
    isActive,
    fcmToken,
  ];
}
