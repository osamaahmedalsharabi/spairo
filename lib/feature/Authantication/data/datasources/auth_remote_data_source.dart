import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

class AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore db;
  final FirebaseStorage storage;
  AuthRemoteDataSource(this.auth, this.db, this.storage);

  Future<UserModel> login(String email, String pass) async {
    // 1. Find user by email in Firestore
    final query = await db.collection('users')
        .where('email', isEqualTo: email).get();
    if (query.docs.isEmpty) {
      throw Exception('البريد الإلكتروني غير مسجل');
    }
    // 2. Verify password from Firestore
    final doc = query.docs.first;
    final data = doc.data();
    final storedPass = data['password'] ?? '';
    if (storedPass != pass) {
      throw Exception('كلمة المرور غير صحيحة');
    }
    // 3. Sign in with Firebase Auth for session
    try {
      await auth.signInWithEmailAndPassword(
          email: email, password: storedPass);
    } catch (_) {}
    return UserModel.fromJson(data, doc.id);
  }

  Future<UserModel> register(UserEntity user, String pass, File? img) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: user.email,
      password: pass,
    );
    String? imgUrl;
    if (img != null) {
      final ref = storage.ref().child(
        'commercial_registers/${cred.user!.uid}.jpg',
      );
      await ref.putFile(img);
      imgUrl = await ref.getDownloadURL();
    }
    final model = UserModel(
      id: cred.user!.uid,
      name: user.name,
      email: user.email,
      phone: user.phone,
      userType: user.userType,
      commercialRegisterImage: imgUrl,
    );
    await db.collection('users').doc(cred.user!.uid).set({
      ...model.toJson(),
      'password': pass,
    });
    return model;
  }

  Future<UserModel> getUserData(String uid) async {
    final doc = await db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson(doc.data()!, doc.id);
    } else {
      throw Exception('User not found');
    }
  }
}
