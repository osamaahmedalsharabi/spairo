import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../view_model/admin_cubit.dart';

class AdminStatsCards extends StatelessWidget {
  final AdminStats stats;
  final void Function(String type)? onCardTap;

  const AdminStatsCards({
    super.key,
    required this.stats,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _card('إجمالي المستخدمين', '${stats.totalUsers}',
            Icons.people, Colors.blue, 'totalUsers'),
        _card('الموردين', '${stats.suppliers}',
            Icons.store, AppColors.primary, 'suppliers'),
        _card('المهندسين', '${stats.engineers}',
            Icons.engineering, Colors.teal, 'engineers'),
        _card('المستخدمين', '${stats.regularUsers}',
            Icons.person, Colors.purple, 'regularUsers'),
        _card('الحسابات النشطة', '${stats.activeUsers}',
            Icons.verified_user, Colors.green,
            'activeUsers'),
        _card('إجمالي الطلبات', '${stats.totalOrders}',
            Icons.receipt_long, Colors.indigo,
            'totalOrders'),
        _card('طلبات مكتملة', '${stats.completedOrders}',
            Icons.check_circle, Colors.green,
            'completedOrders'),
        _card('الإيرادات',
            '${stats.totalRevenue.toStringAsFixed(0)} ر.س',
            Icons.payments, Colors.amber[800]!,
            'revenue'),
        _card('منتجات بانتظار الموافقة',
            '${stats.pendingProducts}',
            Icons.pending_actions, Colors.deepOrange,
            'pendingProducts'),
        _card('إجمالي المنتجات',
            '${stats.totalProducts}',
            Icons.inventory, Colors.blueGrey,
            'allProducts'),
      ],
    );
  }

  Widget _card(String title, String value,
      IconData icon, Color c, String type) {
    return GestureDetector(
      onTap: () => onCardTap?.call(type),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: c, size: 22),
                Icon(Icons.arrow_forward_ios,
                    color: Colors.grey[300], size: 14),
              ],
            ),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16, color: c)),
            Text(title, style: const TextStyle(
              color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
