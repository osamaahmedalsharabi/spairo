import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/feature/Authantication/data/datasources/auth_local_data_source.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/repo/part_order_repo.dart';

part 'get_user_orders_state.dart';

/// sent = الطلبات المرسلة (supplier sent to other suppliers)
/// incoming = الطلبات الواردة (from other suppliers)
/// myOrders = default main tab (user/engineer own orders OR supplier client orders)
enum OrdersMode { myOrders, sent, incoming }

class GetUserOrdersCubit extends Cubit<GetUserOrdersState> {
  final PartOrderRepoImpl repo;
  final AuthLocalDataSource authLocalDataSource;

  List<PartOrderModel> _allOrders = [];
  OrderStatus? _currentFilter;
  bool _isSupplier = false;
  OrdersMode _mode = OrdersMode.myOrders;

  GetUserOrdersCubit(this.repo, this.authLocalDataSource)
    : super(GetUserOrdersInitial());

  bool get isSupplier => _isSupplier;
  OrderStatus? get currentFilter => _currentFilter;
  OrdersMode get mode => _mode;

  Future<void> getUserOrders({
    OrdersMode? mode,
  }) async {
    if (mode != null) _mode = mode;
    emit(GetUserOrdersLoading());
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(GetUserOrdersGuest());
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (!userDoc.exists) {
        emit(GetUserOrdersGuest());
        return;
      }

      _isSupplier =
          userDoc.data()?['userType'] == 'مورد';

      final result;
      switch (_mode) {
        case OrdersMode.myOrders:
          if (_isSupplier) {
            // Main tab for supplier: client orders (مستخدم/مهندس)
            result = await repo.getIncomingSupplierOrders(uid);
          } else {
            // Main tab for user/engineer: their own orders
            result = await repo.getUserOrders(uid);
          }
        case OrdersMode.incoming:
          // Drawer "الطلبات الواردة": from other suppliers
          result = await repo.getSupplierOrders(uid);
        case OrdersMode.sent:
          // Drawer "الطلبات المرسلة": supplier's own sent orders
          result = await repo.getUserOrders(uid);
      }

      result.fold(
        (error) =>
            emit(GetUserOrdersFailure(message: error)),
        (orders) {
          List<PartOrderModel> finalOrders = orders;
          // Supplier main tab: exclude orders from other suppliers
          if (_isSupplier && _mode == OrdersMode.myOrders) {
            finalOrders = orders
                .where((o) => o.senderType != 'مورد')
                .toList();
          }
          _allOrders = finalOrders;
          _currentFilter = null;
          _emitFiltered();
        },
      );
    } catch (e) {
      emit(GetUserOrdersFailure(
          message: e.toString()));
    }
  }

  void filterByStatus(OrderStatus? status) {
    _currentFilter = status;
    _emitFiltered();
  }

  void _emitFiltered() {
    final filtered = _currentFilter == null
        ? _allOrders
        : _allOrders
            .where((o) => o.status == _currentFilter)
            .toList();
    emit(GetUserOrdersSuccess(
      orders: filtered,
      isSupplier:
          _isSupplier && _mode != OrdersMode.sent,
    ));
  }
}
