import 'package:flutter/material.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'order_card_widget.dart';
import 'orders_shimmer_widget.dart';

class OrdersListWidget extends StatelessWidget {
  final List<PartOrderModel>? orders;
  final bool isLoading;
  final bool isSupplier;
  final String? errorMessage;
  final VoidCallback onRetry;

  const OrdersListWidget({
    super.key,
    this.orders,
    this.isLoading = false,
    this.isSupplier = false,
    this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const OrdersShimmerWidget();
    }

    if (errorMessage != null) {
      return _buildError();
    }

    if (orders == null || orders!.isEmpty) {
      return _buildEmpty();
    }

    return ListView.separated(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
      itemCount: orders!.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
        return OrderCardWidget(order: orders![index], isSupplier: isSupplier);
      },
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'لا توجد طلبات',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
