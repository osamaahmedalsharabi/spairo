import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/category_model.dart';
import 'package:sparioapp/feature/user_feature/home/data/repo/home_repo.dart';

part 'get_categories_state.dart';

class GetCategoriesCubit extends Cubit<GetCategoriesState> {
  final HomeRepoImpl repo;
  GetCategoriesCubit(this.repo) : super(GetCategoriesInitial());

  getCategories() async {
    emit(GetCategoriesLoading());
    try {
      List<CategoryModel> categories = await repo.getCategories();
      emit(GetCategoriesSuccess(categories: categories));
    } catch (e) {
      emit(GetCategoriesFailure(message: e.toString()));
    }
  }
}
