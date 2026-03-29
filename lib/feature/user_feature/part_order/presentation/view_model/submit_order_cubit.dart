import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/repo/part_order_repo.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/Core/services/notification_service.dart';

part 'submit_order_state.dart';

class SubmitOrderCubit extends Cubit<SubmitOrderState> {
  final PartOrderRepoImpl repo;

  SubmitOrderCubit(this.repo) : super(SubmitOrderInitial());

  Future<void> submitOrder(PartOrderModel order, File? image) async {
    emit(SubmitOrderLoading());
    final result = await repo.submitOrder(order, image);

    result.fold(
      (error) => emit(SubmitOrderFailure(message: error)),
      (savedOrder) {
        sl.get<NotificationService>().sendOrderNotificationToSupplier(savedOrder);
        emit(SubmitOrderSuccess());
      },
    );
  }
}
