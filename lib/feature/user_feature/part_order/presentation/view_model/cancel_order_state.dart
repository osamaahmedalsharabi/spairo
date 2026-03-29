part of 'cancel_order_cubit.dart';

sealed class CancelOrderState {}

final class CancelOrderInitial extends CancelOrderState {}

final class CancelOrderLoading extends CancelOrderState {}

final class CancelOrderSuccess extends CancelOrderState {}

final class CancelOrderFailure extends CancelOrderState {
  final String message;
  CancelOrderFailure({required this.message});
}
