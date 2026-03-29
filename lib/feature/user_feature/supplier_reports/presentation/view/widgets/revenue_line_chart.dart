import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../view_model/report_cubit.dart';

class RevenueLineChart extends StatelessWidget {
  final ReportStats stats;
  const RevenueLineChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final entries = stats.monthlyRevenue.entries.toList();
    if (entries.isEmpty) return const SizedBox();

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
          const Text('الإيرادات الشهرية',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: _spots(entries),
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ],
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
                      if (i < 0 || i >= entries.length) {
                        return const SizedBox();
                      }
                      return Text(entries[i].key,
                          style: const TextStyle(fontSize: 9));
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (v) =>
                    FlLine(color: Colors.grey[200]!, strokeWidth: 1),
              ),
            )),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _spots(
      List<MapEntry<String, double>> entries) {
    return List.generate(entries.length, (i) {
      return FlSpot(i.toDouble(), entries[i].value);
    });
  }
}
