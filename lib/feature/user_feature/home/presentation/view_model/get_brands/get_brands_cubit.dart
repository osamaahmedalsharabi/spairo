import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import 'package:sparioapp/feature/user_feature/home/data/repo/home_repo.dart';

part 'get_brands_state.dart';

class GetBrandsCubit extends Cubit<GetBrandsState> {
  final HomeRepoImpl repo;
  GetBrandsCubit(this.repo) : super(GetBrandsInitial());

  getBrands() async {
    emit(GetBrandsLoading());
    try {
      List<BrandModel> brands = await repo.getBrands();
      emit(GetBrandsSuccess(brands: brands));
    } catch (e) {
      emit(GetBrandsFailure(message: e.toString()));
    }
  }
}
