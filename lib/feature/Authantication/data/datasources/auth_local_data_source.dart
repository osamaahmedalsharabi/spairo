import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

class AuthLocalDataSource {
  static const String _userBox = 'userBox';
  static const String _userKey = 'currentUser';

  final Box box;

  AuthLocalDataSource(this.box);

  Future<void> saveUser(UserEntity user) async {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      userType: user.userType,
      commercialRegisterImage: user.commercialRegisterImage,
      isActive: user.isActive,
    );
    // Store as JSON string so we don't need to define TypeAdapters for now
    final jsonString = jsonEncode(userModel.toJson());
    // Also save the ID since we need it for fromJson, or embed it in the JSON string
    final Map<String, dynamic> dataToStore = {
      'id': user.id,
      'data': jsonString,
    };
    await box.put(_userKey, jsonEncode(dataToStore));
  }

  Future<UserModel?> getUser() async {
    final String? cachedData = box.get(_userKey);
    if (cachedData != null) {
      final Map<String, dynamic> decodedData = jsonDecode(cachedData);
      final String id = decodedData['id'];
      final Map<String, dynamic> userJson = jsonDecode(decodedData['data']);
      return UserModel.fromJson(userJson, id);
    }
    return null;
  }

  Future<void> clearUser() async {
    await box.delete(_userKey);
  }
}
