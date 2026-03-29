part of 'get_user_orders_cubit.dart';

sealed class GetUserOrdersState {}

final class GetUserOrdersInitial extends GetUserOrdersState {}

final class GetUserOrdersLoading extends GetUserOrdersState {}

final class GetUserOrdersSuccess extends GetUserOrdersState {
  final List<PartOrderModel> orders;
  final bool isSupplier;
  GetUserOrdersSuccess({
    required this.orders,
    this.isSupplier = false,
  });
}

final class GetUserOrdersFailure extends GetUserOrdersState {
  final String message;
  GetUserOrdersFailure({required this.message});
}

final class GetUserOrdersGuest extends GetUserOrdersState {}
