import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparioapp/Core/errors/firebase_error_helper.dart';
import 'package:sparioapp/feature/Authantication/data/models/user_model.dart';

class ExpertsRepoImpl {
  final FirebaseFirestore firestore;

  ExpertsRepoImpl(this.firestore);

  Future<List<UserModel>> getExperts() async {
    try {
      final snapshot = await firestore
          .collection('users')
          .where('userType', isEqualTo: 'مهندس')
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.getErrorMessage(e));
    }
  }
}
