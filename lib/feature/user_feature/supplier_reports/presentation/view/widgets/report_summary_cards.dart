import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../view_model/report_cubit.dart';

class ReportSummaryCards extends StatelessWidget {
  final ReportStats stats;
  const ReportSummaryCards({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _card('إجمالي الطلبات', '${stats.total}',
            Icons.receipt_long, Colors.blue),
        _card('الإيرادات', '${stats.totalRevenue.toStringAsFixed(0)} ر.س',
            Icons.payments, Colors.green),
        _card('مكتملة', '${stats.completed}',
            Icons.check_circle, AppColors.primary),
        _card('ملغاة', '${stats.cancelled}',
            Icons.cancel, Colors.red),
      ],
    );
  }

  Widget _card(String title, String value,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              )),
          Text(title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              )),
        ],
      ),
    );
  }
}
