part of 'get_experts_cubit.dart';

sealed class GetExpertsState {}

final class GetExpertsInitial extends GetExpertsState {}

final class GetExpertsLoading extends GetExpertsState {}

final class GetExpertsSuccess extends GetExpertsState {
  final List<UserModel> experts;

  GetExpertsSuccess(this.experts);
}

final class GetExpertsFailure extends GetExpertsState {
  final String message;

  GetExpertsFailure(this.message);
}
