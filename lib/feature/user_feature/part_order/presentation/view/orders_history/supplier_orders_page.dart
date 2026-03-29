import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/get_user_orders_cubit.dart';
import 'orders_history_view.dart';

class SupplierOrdersPage extends StatelessWidget {
  final OrdersMode mode;

  const SupplierOrdersPage({
    super.key,
    required this.mode,
  });

  String get _title =>
      mode == OrdersMode.incoming
          ? 'الطلبات الواردة'
          : 'الطلبات المرسلة';

  IconData get _icon =>
      mode == OrdersMode.incoming
          ? Icons.inbox_rounded
          : Icons.outbox_rounded;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<GetUserOrdersCubit>()
            ..getUserOrders(mode: mode),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icon, size: 22),
              const SizedBox(width: 8),
              Text(_title),
            ],
          ),
          centerTitle: true,
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
        ),
        body: const OrdersHistoryView(),
      ),
    );
  }
}
