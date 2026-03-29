part of 'get_brand_cars_cubit.dart';

sealed class GetBrandCarsState extends Equatable {
  const GetBrandCarsState();

  @override
  List<Object> get props => [];
}

final class GetBrandCarsInitial extends GetBrandCarsState {}

final class GetBrandCarsLoading extends GetBrandCarsState {}

final class GetBrandCarsSuccess extends GetBrandCarsState {
  final List<BrandModel> cars;
  const GetBrandCarsSuccess({required this.cars});
}

final class GetBrandCarsFailure extends GetBrandCarsState {
  final String message;
  const GetBrandCarsFailure({required this.message});
}
