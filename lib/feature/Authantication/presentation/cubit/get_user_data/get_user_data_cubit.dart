import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repo.dart';
import 'get_user_data_state.dart';

class GetUserDataCubit extends Cubit<GetUserDataState> {
  final AuthRepo repo;

  GetUserDataCubit(this.repo) : super(GetUserDataInitial());

  Future<void> getUserData(String uid) async {
    emit(GetUserDataLoading());
    final res = await repo.getUserData(uid);
    res.fold(
      (err) => emit(GetUserDataFailure(err)),
      (user) => emit(GetUserDataSuccess(user)),
    );
  }
}
