import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../../data/models/part_order_model.dart';

class OrderTrackingHeader extends StatelessWidget {
  final PartOrderModel order;
  const OrderTrackingHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMMM, yyyy', 'ar')
        .format(order.createdAt);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طلب رقم: #${order.orderNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text('تم الطلب : $date',
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  '${order.productPrice?.toStringAsFixed(0) ?? '—'} ريال',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inventory_2_outlined,
                color: AppColors.primary, size: 28),
          ),
        ],
      ),
    );
  }
}
