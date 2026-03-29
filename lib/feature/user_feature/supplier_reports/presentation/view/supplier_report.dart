import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/repo/part_order_repo.dart';
import '../view_model/report_cubit.dart';
import 'widgets/report_summary_cards.dart';
import 'widgets/order_status_chart.dart';
import 'widgets/category_bar_chart.dart';
import 'widgets/revenue_line_chart.dart';

class SupplierReport extends StatelessWidget {
  const SupplierReport({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ReportCubit(sl.get<PartOrderRepoImpl>())..loadReport(),
      child: const _ReportBody(),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text('التقارير',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios,
              color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(
                child: CircularProgressIndicator());
          }
          if (state is ReportError) {
            return Center(child: Text(state.message));
          }
          if (state is ReportLoaded) {
            return _buildReport(state.stats);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildReport(ReportStats stats) {
    if (stats.total == 0) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_outlined,
                size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد بيانات لعرضها',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                )),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ReportSummaryCards(stats: stats),
            const SizedBox(height: 20),
            OrderStatusChart(stats: stats),
            const SizedBox(height: 20),
            CategoryBarChart(stats: stats),
            const SizedBox(height: 20),
            RevenueLineChart(stats: stats),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}