import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  ProfileRepositoryImpl(this._db, this._auth);

  CollectionReference get _users => _db.collection('users');

  @override
  Future<void> updateName(String uid, String name) =>
      _users.doc(uid).update({'name': name});

  @override
  Future<void> updateLocation(String uid, String loc) =>
      _users.doc(uid).update({'location': loc});

  @override
  Future<void> updatePhone(String uid, String phone) =>
      _users.doc(uid).update({'phone': phone});

  @override
  Future<void> updateEmail(String uid, String email) =>
      _users.doc(uid).update({'email': email});

  @override
  Future<void> changePassword(
      String uid, String oldP, String newP) async {
    final doc = await _users.doc(uid).get();
    final data = doc.data() as Map<String, dynamic>?;
    final stored = data?['password'] ?? '';
    if (stored != oldP) {
      throw Exception('كلمة المرور القديمة غير صحيحة');
    }
    await _users.doc(uid).update({'password': newP});
    await _syncAuthPassword(
        data?['email'] ?? '', oldP, newP);
  }

  Future<void> _syncAuthPassword(
      String email, String old, String newP) async {
    try {
      final u = _auth.currentUser;
      if (u == null) return;
      final c = EmailAuthProvider.credential(
          email: email, password: old);
      await u.reauthenticateWithCredential(c);
      await u.updatePassword(newP);
    } catch (_) {}
  }
}
