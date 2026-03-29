import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../view_model/report_cubit.dart';

class CategoryBarChart extends StatelessWidget {
  final ReportStats stats;
  const CategoryBarChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final entries = stats.categoryCount.entries.toList();
    if (entries.isEmpty) return const SizedBox();
    entries.sort((a, b) => b.value.compareTo(a.value));
    final top = entries.take(6).toList();

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
          const Text('الطلبات حسب الصنف',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: _groups(top),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, m) {
                      final i = v.toInt();
                      if (i < 0 || i >= top.length) {
                        return const SizedBox();
                      }
                      final t = top[i].key;
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          t.length > 6
                              ? '${t.substring(0, 6)}..'
                              : t,
                          style: const TextStyle(fontSize: 9),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
            )),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _groups(
      List<MapEntry<String, int>> top) {
    final colors = [
      AppColors.primary,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return List.generate(top.length, (i) {
      return BarChartGroupData(x: i, barRods: [
        BarChartRodData(
          toY: top[i].value.toDouble(),
          color: colors[i % colors.length],
          width: 18,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(6)),
        ),
      ]);
    });
  }
}
