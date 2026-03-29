import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/repo/part_order_repo.dart';

part 'update_order_status_state.dart';

class UpdateOrderStatusCubit
    extends Cubit<UpdateOrderStatusState> {
  final PartOrderRepoImpl repo;

  UpdateOrderStatusCubit(this.repo)
      : super(UpdateOrderStatusInitial());

  Future<void> updateStatus(
    String orderId,
    OrderStatus status,
  ) async {
    emit(UpdateOrderStatusLoading());
    final result =
        await repo.updateOrderStatus(orderId, status);

    result.fold(
      (error) =>
          emit(UpdateOrderStatusFailure(message: error)),
      (_) => emit(UpdateOrderStatusSuccess()),
    );
  }
}
