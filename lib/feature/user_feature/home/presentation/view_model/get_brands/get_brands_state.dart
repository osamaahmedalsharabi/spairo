part of 'get_brands_cubit.dart';

sealed class GetBrandsState extends Equatable {
  const GetBrandsState();

  @override
  List<Object> get props => [];
}

final class GetBrandsInitial extends GetBrandsState {}

final class GetBrandsLoading extends GetBrandsState {}

final class GetBrandsSuccess extends GetBrandsState {
  final List<BrandModel> brands;
  const GetBrandsSuccess({required this.brands});
}

final class GetBrandsFailure extends GetBrandsState {
  final String message;
  const GetBrandsFailure({required this.message});
}
