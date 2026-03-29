import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../view_model/report_cubit.dart';

class OrderStatusChart extends StatelessWidget {
  final ReportStats stats;
  const OrderStatusChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.total == 0) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          const Text('توزيع حالات الطلبات',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: PieChart(PieChartData(
              sections: _sections(),
              centerSpaceRadius: 36,
              sectionsSpace: 2,
            )),
          ),
          const SizedBox(height: 12),
          _legend(),
        ],
      ),
    );
  }

  List<PieChartSectionData> _sections() {
    final total = stats.total.toDouble();
    return [
      _sec(stats.pending / total * 100,
          Colors.orange, 'مراجعة'),
      _sec(stats.inProgress / total * 100,
          Colors.blue, 'تنفيذ'),
      _sec(stats.completed / total * 100,
          AppColors.primary, 'مكتمل'),
      _sec(stats.cancelled / total * 100,
          Colors.red, 'ملغي'),
    ].where((s) => s.value > 0).toList();
  }

  PieChartSectionData _sec(
      double val, Color c, String t) {
    return PieChartSectionData(
      value: val,
      color: c,
      radius: 28,
      title: '${val.toStringAsFixed(0)}%',
      titleStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _legend() {
    final items = [
      _LegendItem('قيد المراجعة', Colors.orange, stats.pending),
      _LegendItem('قيد التنفيذ', Colors.blue, stats.inProgress),
      _LegendItem('مكتمل', AppColors.primary, stats.completed),
      _LegendItem('ملغي', Colors.red, stats.cancelled),
    ].where((i) => i.count > 0).toList();

    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: items.map((i) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10,
              decoration: BoxDecoration(
                color: i.color,
                shape: BoxShape.circle,
              )),
          const SizedBox(width: 4),
          Text('${i.label} (${i.count})',
              style: const TextStyle(fontSize: 11)),
        ],
      )).toList(),
    );
  }
}

class _LegendItem {
  final String label;
  final Color color;
  final int count;
  _LegendItem(this.label, this.color, this.count);
}
