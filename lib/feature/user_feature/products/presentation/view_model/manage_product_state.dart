import 'package:equatable/equatable.dart';

abstract class ManageProductState extends Equatable {
  const ManageProductState();

  @override
  List<Object> get props => [];
}

class ManageProductInitial extends ManageProductState {}

class ManageProductLoading extends ManageProductState {}

class ManageProductSuccess extends ManageProductState {
  final String message;

  const ManageProductSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ManageProductFailure extends ManageProductState {
  final String message;

  const ManageProductFailure(this.message);

  @override
  List<Object> get props => [message];
}
