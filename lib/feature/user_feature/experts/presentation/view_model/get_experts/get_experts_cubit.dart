import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/feature/Authantication/data/models/user_model.dart';
import 'package:sparioapp/feature/user_feature/experts/data/repo/experts_repo.dart';

part 'get_experts_state.dart';

class GetExpertsCubit extends Cubit<GetExpertsState> {
  final ExpertsRepoImpl expertsRepo;

  GetExpertsCubit(this.expertsRepo) : super(GetExpertsInitial());

  Future<void> getExperts() async {
    emit(GetExpertsLoading());
    try {
      final experts = await expertsRepo.getExperts();
      emit(GetExpertsSuccess(experts));
    } catch (e) {
      emit(GetExpertsFailure(e.toString()));
    }
  }
}
