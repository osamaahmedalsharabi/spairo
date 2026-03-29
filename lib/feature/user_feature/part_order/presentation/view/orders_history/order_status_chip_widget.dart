import 'package:flutter/material.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';

class OrderStatusChipWidget extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChipWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case OrderStatus.pending:
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case OrderStatus.inProgress:
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case OrderStatus.completed:
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case OrderStatus.cancelled:
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.value,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
