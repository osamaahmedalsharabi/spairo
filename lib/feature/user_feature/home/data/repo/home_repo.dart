import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparioapp/Core/errors/firebase_error_helper.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/category_model.dart';

class HomeRepoImpl {
  final FirebaseFirestore firestore;
  HomeRepoImpl(this.firestore);

  Future<List<BrandModel>> getBrands() async {
    try {
      List<BrandModel> brands = await firestore
          .collection('brands')
          .get()
          .then(
            (value) => value.docs
                .map((e) => BrandModel.fromJson(e.data(), e.id))
                .toList(),
          );
      return brands;
    } catch (e) {
      throw Exception(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  Future<List<BrandModel>> getBrandCars(String brandId) async {
    try {
      List<BrandModel> cars = await firestore
          .collection('brands')
          .doc(brandId)
          .collection('cars')
          .get()
          .then(
            (value) => value.docs
                .map((e) => BrandModel.fromJson(e.data(), e.id))
                .toList(),
          );
      return cars;
    } catch (e) {
      throw Exception(FirebaseErrorHandler.getErrorMessage(e));
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      List<CategoryModel> categories = await firestore
          .collection('Auto parts classifications')
          .get()
          .then(
            (value) => value.docs
                .map((e) => CategoryModel.fromJson(e.data()))
                .toList(),
          );
      return categories;
    } catch (e) {
      throw Exception(FirebaseErrorHandler.getErrorMessage(e));
    }
  }
}
