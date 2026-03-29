part of 'get_categories_cubit.dart';

sealed class GetCategoriesState extends Equatable {
  const GetCategoriesState();

  @override
  List<Object> get props => [];
}

final class GetCategoriesInitial extends GetCategoriesState {}

final class GetCategoriesLoading extends GetCategoriesState {}

final class GetCategoriesSuccess extends GetCategoriesState {
  final List<CategoryModel> categories;
  const GetCategoriesSuccess({required this.categories});
}

final class GetCategoriesFailure extends GetCategoriesState {
  final String message;
  const GetCategoriesFailure({required this.message});
}
