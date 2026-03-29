import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class GetUserDataState extends Equatable {
  const GetUserDataState();

  @override
  List<Object> get props => [];
}

class GetUserDataInitial extends GetUserDataState {}

class GetUserDataLoading extends GetUserDataState {}

class GetUserDataSuccess extends GetUserDataState {
  final UserEntity user;

  const GetUserDataSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class GetUserDataFailure extends GetUserDataState {
  final String message;

  const GetUserDataFailure(this.message);

  @override
  List<Object> get props => [message];
}
