import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';

class OrderFilterTabsWidget extends StatelessWidget {
  final OrderStatus? selectedStatus;
  final ValueChanged<OrderStatus?> onStatusChanged;

  const OrderFilterTabsWidget({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTab(null, 'الكل'),
          _buildTab(OrderStatus.pending, 'قيد المراجعة'),
          _buildTab(OrderStatus.inProgress, 'قيد التنفيذ'),
          _buildTab(OrderStatus.completed, 'مكتمل'),
          _buildTab(OrderStatus.cancelled, 'ملغي'),
        ],
      ),
    );
  }

  Widget _buildTab(OrderStatus? status, String label) {
    final isSelected = selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Colors.grey[700],
        ),
        backgroundColor: Colors.grey[200],
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (_) => onStatusChanged(status),
      ),
    );
  }
}
