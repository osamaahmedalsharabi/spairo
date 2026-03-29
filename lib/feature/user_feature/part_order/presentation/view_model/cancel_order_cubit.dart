import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/repo/part_order_repo.dart';

part 'cancel_order_state.dart';

class CancelOrderCubit extends Cubit<CancelOrderState> {
  final PartOrderRepoImpl repo;

  CancelOrderCubit(this.repo) : super(CancelOrderInitial());

  Future<void> cancelOrder(String orderId) async {
    emit(CancelOrderLoading());
    final result = await repo.cancelOrder(orderId);

    result.fold(
      (error) => emit(CancelOrderFailure(message: error)),
      (_) => emit(CancelOrderSuccess()),
    );
  }
}
