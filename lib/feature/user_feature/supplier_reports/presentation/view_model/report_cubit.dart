import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../part_order/data/repo/part_order_repo.dart';
import '../../../part_order/data/models/part_order_model.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final PartOrderRepoImpl _repo;

  ReportCubit(this._repo) : super(ReportInitial());

  Future<void> loadReport() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    emit(ReportLoading());

    final result = await _repo.getIncomingSupplierOrders(uid);
    result.fold(
      (error) => emit(ReportError(error)),
      (orders) => emit(ReportLoaded(
        orders: orders,
        stats: ReportStats.fromOrders(orders),
      )),
    );
  }
}
