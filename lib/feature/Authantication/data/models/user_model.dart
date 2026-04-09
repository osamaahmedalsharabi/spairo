import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.userType,
    super.location,
    super.commercialRegisterImage,
    super.isActive,
    super.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['userType'] ?? 'مستخدم',
      commercialRegisterImage: json['commercialRegisterImage'],
      isActive: json['is_active'] ?? false,
      fcmToken: json['fcmToken'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'is_active': isActive,
      if (commercialRegisterImage != null)
        'commercialRegisterImage': commercialRegisterImage,
      if (fcmToken != null) 'fcmToken': fcmToken,
    };
  }
}
