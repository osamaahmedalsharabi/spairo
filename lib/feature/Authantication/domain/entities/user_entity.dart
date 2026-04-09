import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final String? location;
  final String? commercialRegisterImage;
  final bool isActive;
  final String? fcmToken;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.location,
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

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? location,
    String? commercialRegisterImage,
    bool? isActive,
    String? fcmToken,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      location: location ?? this.location,
      commercialRegisterImage: commercialRegisterImage ?? this.commercialRegisterImage,
      isActive: isActive ?? this.isActive,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}

