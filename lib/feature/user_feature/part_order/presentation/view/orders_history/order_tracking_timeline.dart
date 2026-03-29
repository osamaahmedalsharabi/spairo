import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../../data/models/part_order_model.dart';

class OrderTrackingTimeline extends StatelessWidget {
  final PartOrderModel order;
  const OrderTrackingTimeline({super.key, required this.order});

  int get _activeIndex {
    switch (order.status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.inProgress:
        return 2;
      case OrderStatus.completed:
        return 4;
      case OrderStatus.cancelled:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMMM , yyyy', 'ar')
        .format(order.createdAt);
    final active = _activeIndex;

    final steps = [
      _Step('تتبع الطلب', date,
          Icons.inventory_2_outlined, active >= 0),
      _Step('قبول الطلب', active >= 1 ? date : 'قيد الانتظار',
          Icons.check_circle_outline, active >= 1),
      _Step('تم شحن الطلب', active >= 2 ? date : 'قيد الانتظار',
          Icons.location_on_outlined, active >= 2),
      _Step('خرج للتوصيل', active >= 3 ? date : 'قيد الانتظار',
          Icons.local_shipping_outlined, active >= 3),
      _Step('تم تسليم', active >= 4 ? date : 'قيد الانتظار',
          Icons.shopping_cart_checkout, active >= 4),
    ];

    if (order.status == OrderStatus.cancelled) {
      return _buildCancelledView(date);
    }

    return Column(
      children: List.generate(steps.length, (i) {
        return _TimelineItem(
          step: steps[i],
          isLast: i == steps.length - 1,
        );
      }),
    );
  }

  Widget _buildCancelledView(String date) {
    return Column(
      children: [
        _TimelineItem(
          step: _Step('تتبع الطلب', date,
              Icons.inventory_2_outlined, true),
          isLast: false,
        ),
        _TimelineItem(
          step: _Step('تم إلغاء الطلب', date,
              Icons.cancel_outlined, true,
              isCancelled: true),
          isLast: true,
        ),
      ],
    );
  }
}

class _Step {
  final String title, subtitle;
  final IconData icon;
  final bool done;
  final bool isCancelled;

  _Step(this.title, this.subtitle, this.icon, this.done,
      {this.isCancelled = false});
}

class _TimelineItem extends StatelessWidget {
  final _Step step;
  final bool isLast;

  const _TimelineItem({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = step.isCancelled
        ? Colors.red
        : step.done
            ? AppColors.primary
            : Colors.grey[300]!;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.15),
                  ),
                  child: Icon(step.icon, color: color, size: 20),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: step.done
                          ? AppColors.primary.withOpacity(0.3)
                          : Colors.grey[200],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: step.isCancelled
                            ? Colors.red
                            : Colors.black,
                      )),
                  const SizedBox(height: 4),
                  Text(step.subtitle,
                      style: TextStyle(
                        color: step.done
                            ? Colors.grey
                            : Colors.grey[400],
                        fontSize: 12,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
