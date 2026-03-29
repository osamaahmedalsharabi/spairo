import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/get_user_orders_cubit.dart';
import 'order_filter_tabs_widget.dart';
import 'orders_list_widget.dart';

class OrdersHistoryView extends StatefulWidget {
  const OrdersHistoryView({super.key});

  @override
  State<OrdersHistoryView> createState() => _OrdersHistoryViewState();
}

class _OrdersHistoryViewState extends State<OrdersHistoryView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetUserOrdersCubit>().getUserOrders();
      },
      child: BlocBuilder<GetUserOrdersCubit, GetUserOrdersState>(
        builder: (context, state) {
          if (state is GetUserOrdersGuest) {
            return _buildGuestView(context);
          } else if (state is GetUserOrdersLoading) {
            return _buildLoadingView();
          } else if (state is GetUserOrdersSuccess) {
            return _buildSuccessView(context, state);
          } else if (state is GetUserOrdersFailure) {
            return _buildErrorView(context, state);
          }
          return _buildLoadingView();
        },
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, GetUserOrdersSuccess state) {
    final cubit = context.read<GetUserOrdersCubit>();
    return Column(
      children: [
        const SizedBox(height: 12),
        OrderFilterTabsWidget(
          selectedStatus: cubit.currentFilter,
          onStatusChanged: (status) {
            cubit.filterByStatus(status);
          },
        ),
        const SizedBox(height: 8),
        Expanded(
          child: OrdersListWidget(
            orders: state.orders,
            isSupplier: state.isSupplier,
            onRetry: () => cubit.getUserOrders(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return Column(
      children: [
        const SizedBox(height: 12),
        OrderFilterTabsWidget(selectedStatus: null, onStatusChanged: (_) {}),
        const SizedBox(height: 8),
        const Expanded(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, GetUserOrdersFailure state) {
    return OrdersListWidget(
      errorMessage: state.message,
      onRetry: () => context.read<GetUserOrdersCubit>().getUserOrders(),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'يجب تسجيل الدخول لعرض الطلبات',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(40),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(16)),
                  ),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.push("/login");
                },
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
