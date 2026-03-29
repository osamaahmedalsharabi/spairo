part of 'update_order_status_cubit.dart';

sealed class UpdateOrderStatusState {}

final class UpdateOrderStatusInitial
    extends UpdateOrderStatusState {}

final class UpdateOrderStatusLoading
    extends UpdateOrderStatusState {}

final class UpdateOrderStatusSuccess
    extends UpdateOrderStatusState {}

final class UpdateOrderStatusFailure
    extends UpdateOrderStatusState {
  final String message;
  UpdateOrderStatusFailure({required this.message});
}
