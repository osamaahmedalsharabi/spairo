part of 'report_cubit.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportError extends ReportState {
  final String message;
  ReportError(this.message);
}

class ReportLoaded extends ReportState {
  final List<PartOrderModel> orders;
  final ReportStats stats;
  ReportLoaded({required this.orders, required this.stats});
}

class ReportStats {
  final int total;
  final int pending;
  final int inProgress;
  final int completed;
  final int cancelled;
  final double totalRevenue;
  final Map<String, int> categoryCount;
  final Map<String, double> monthlyRevenue;

  ReportStats({
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.cancelled,
    required this.totalRevenue,
    required this.categoryCount,
    required this.monthlyRevenue,
  });

  factory ReportStats.fromOrders(List<PartOrderModel> orders) {
    int p = 0, ip = 0, c = 0, ca = 0;
    double rev = 0;
    final Map<String, int> cats = {};
    final Map<String, double> monthly = {};

    for (final o in orders) {
      switch (o.status) {
        case OrderStatus.pending:
          p++;
        case OrderStatus.inProgress:
          ip++;
        case OrderStatus.completed:
          c++;
          rev += o.productPrice ?? 0;
        case OrderStatus.cancelled:
          ca++;
      }
      cats[o.categoryName] = (cats[o.categoryName] ?? 0) + 1;

      final key = '${o.createdAt.month}/${o.createdAt.year}';
      if (o.status == OrderStatus.completed) {
        monthly[key] =
            (monthly[key] ?? 0) + (o.productPrice ?? 0);
      }
    }

    return ReportStats(
      total: orders.length,
      pending: p,
      inProgress: ip,
      completed: c,
      cancelled: ca,
      totalRevenue: rev,
      categoryCount: cats,
      monthlyRevenue: monthly,
    );
  }
}
