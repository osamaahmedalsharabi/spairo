import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import 'package:sparioapp/feature/user_feature/home/data/repo/home_repo.dart';

part 'get_brand_cars_state.dart';

class GetBrandCarsCubit extends Cubit<GetBrandCarsState> {
  final HomeRepoImpl repo;
  GetBrandCarsCubit(this.repo) : super(GetBrandCarsInitial());

  getBrandCars(String brandId) async {
    emit(GetBrandCarsLoading());
    try {
      List<BrandModel> cars = await repo.getBrandCars(brandId);
      emit(GetBrandCarsSuccess(cars: cars));
    } catch (e) {
      emit(GetBrandCarsFailure(message: e.toString()));
    }
  }
}
