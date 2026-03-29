part of 'submit_order_cubit.dart';

sealed class SubmitOrderState {}

final class SubmitOrderInitial extends SubmitOrderState {}

final class SubmitOrderLoading extends SubmitOrderState {}

final class SubmitOrderSuccess extends SubmitOrderState {}

final class SubmitOrderFailure extends SubmitOrderState {
  final String message;
  SubmitOrderFailure({required this.message});
}
