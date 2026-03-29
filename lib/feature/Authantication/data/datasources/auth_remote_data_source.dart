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

  Future<UserModel> login(String email, String pass,) async {
    final cred = await auth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );
    final doc = await db.collection('users').doc(cred.user!.uid).get();

    // if (doc.exists && doc.data()?['userType'] != userType) {
    //   await auth.signOut();
    //   throw FirebaseAuthException(
    //     code: 'user-mismatch',
    //     message: 'نوع الحساب المختار لا يتطابق مع نوع حسابك الفعلي',
    //   );
    // }

    return UserModel.fromJson(doc.data()!, doc.id);
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
    await db.collection('users').doc(cred.user!.uid).set(model.toJson());
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
