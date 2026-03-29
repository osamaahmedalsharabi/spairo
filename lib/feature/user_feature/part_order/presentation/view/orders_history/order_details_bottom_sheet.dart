import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/Widgets/custom_alert_dialog_widget.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/cancel_order_cubit.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/update_order_status_cubit.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/get_user_orders_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/Core/services/notification_service.dart';
import 'order_status_chip_widget.dart';

class OrderDetailsBottomSheet extends StatefulWidget {
  final PartOrderModel order;
  final bool isSupplier;

  const OrderDetailsBottomSheet({
    super.key,
    required this.order,
    this.isSupplier = false,
  });

  @override
  State<OrderDetailsBottomSheet> createState() => _OrderDetailsBottomSheetState();
}

class _OrderDetailsBottomSheetState extends State<OrderDetailsBottomSheet> {
  late OrderStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<CancelOrderCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<UpdateOrderStatusCubit>(),
        ),
      ],
      child: Builder(
        builder: (context) => _buildListeners(context),
      ),
    );
  }

  Widget _buildListeners(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CancelOrderCubit, CancelOrderState>(
          listener: (context, state) {
            String? error;
            if (state is CancelOrderFailure) {
              error = state.message;
            }
            if (state is CancelOrderSuccess) {
              sl.get<NotificationService>().sendOrderStatusNotification(
                    widget.order.copyWith(status: OrderStatus.cancelled),
                  );
            }
            _handleStatusChange(context, state is CancelOrderLoading,
                state is CancelOrderSuccess,
                error,
                'تم إلغاء الطلب بنجاح');
          },
        ),
        BlocListener<UpdateOrderStatusCubit, UpdateOrderStatusState>(
          listener: (context, state) {
            String? error;
            if (state is UpdateOrderStatusFailure) {
              error = state.message;
            }
            if (state is UpdateOrderStatusSuccess) {
              sl.get<NotificationService>().sendOrderStatusNotification(
                    widget.order.copyWith(status: _currentStatus),
                  );
            }
            _handleStatusChange(
                context,
                state is UpdateOrderStatusLoading,
                state is UpdateOrderStatusSuccess,
                error,
                'تم تحديث حالة الطلب بنجاح');
          },
        ),
      ],
      child: _buildContent(context),
    );
  }

  void _handleStatusChange(
    BuildContext context,
    bool isLoading,
    bool isSuccess,
    String? errorMessage,
    String successMessage,
  ) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (isSuccess) {
      Navigator.pop(context); // close loading
      Navigator.pop(context); // close bottom sheet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: Colors.green,
        ),
      );
      context.read<GetUserOrdersCubit>().getUserOrders();
    } else if (errorMessage != null) {
      Navigator.pop(context); // close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(),
          const SizedBox(height: 20),
          _buildHeader(),
          const Divider(height: 30),
          Expanded(child: _buildDetails()),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'طلب ${widget.order.orderNumber}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        OrderStatusChipWidget(status: _currentStatus),
      ],
    );
  }

  Widget _buildDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
              'الشركة المصنعة', widget.order.companyName),
          _buildDetailRow('اسم السيارة', widget.order.carName),
          _buildDetailRow(
              'موديل السيارة', widget.order.carYear),
          _buildDetailRow(
              'القطعة المطلوبة', widget.order.categoryName),
          _buildDetailRow('حالة القطعة', widget.order.condition),
          if (widget.order.partName.isNotEmpty)
            _buildDetailRow('اسم تفصيلي', widget.order.partName),
          if (widget.order.partNumber.isNotEmpty)
            _buildDetailRow(
                'رقم القطعة', widget.order.partNumber),
          if (widget.order.productPrice != null)
            _buildDetailRow(
                'السعر',
                '${widget.order.productPrice!.toStringAsFixed(0)} ر.س'),
          if (widget.order.details.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'وصف إضافي:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(widget.order.details,
                style: const TextStyle(fontSize: 14)),
          ],
          if (widget.order.orderImage != null) ...[
            const SizedBox(height: 20),
            const Text(
              'صورة مرفقة:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.order.orderImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildTrackButton(context),
        if (widget.isSupplier) _buildSupplierActions(context),
        if (!widget.isSupplier && _currentStatus == OrderStatus.pending)
          _buildCancelButton(context),
      ],
    );
  }

  Widget _buildTrackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            context.pushNamed(
              AppRouteConst.orderTracking,
              extra: widget.order,
            );
          },
          icon: const Icon(Icons.local_shipping_outlined,
              size: 20),
          label: const Text(
            'متابعة الطلب',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupplierActions(BuildContext context) {
    if (_currentStatus == OrderStatus.pending) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            Expanded(
              child: _buildActionBtn(
                context: context,
                label: 'قبول الطلب',
                color: Colors.green,
                icon: Icons.check_circle_outline,
                onTap: () =>
                    _confirmAction(
                      context,
                      'تأكيد القبول',
                      'هل أنت متأكد من قبول هذا الطلب؟',
                      OrderStatus.inProgress,
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionBtn(
                context: context,
                label: 'رفض الطلب',
                color: Colors.red,
                icon: Icons.cancel_outlined,
                onTap: () =>
                    _confirmAction(
                      context,
                      'تأكيد الرفض',
                      'هل أنت متأكد من رفض هذا الطلب؟',
                      OrderStatus.cancelled,
                    ),
              ),
            ),
          ],
        ),
      );
    }

    if (_currentStatus == OrderStatus.inProgress) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: _buildActionBtn(
          context: context,
          label: 'تم التسليم',
          color: AppColors.primary,
          icon: Icons.done_all,
          onTap: () =>
              _confirmAction(
                context,
                'تأكيد التسليم',
                'هل تم تسليم هذا الطلب؟',
                OrderStatus.completed,
              ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildActionBtn({
    required BuildContext context,
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _confirmAction(
    BuildContext context,
    String title,
    String content,
    OrderStatus newStatus,
  ) {
    if (widget.order.id == null) return;

    final updateCubit =
        context.read<UpdateOrderStatusCubit>();
    final cancelCubit =
        context.read<CancelOrderCubit>();

    CustomAlertDialogWidget.show(
      context: context,
      title: title,
      content: content,
      onPrimaryPressed: () {
        Navigator.pop(context); // close dialog
        if (newStatus == OrderStatus.cancelled) {
          cancelCubit.cancelOrder(widget.order.id!);
        } else {
          setState(() {
            _currentStatus = newStatus;
          });
          updateCubit.updateStatus(
              widget.order.id!, newStatus);
        }
      },
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    final cubit = context.read<CancelOrderCubit>();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: () {
            CustomAlertDialogWidget.show(
              context: context,
              title: 'تأكيد الإلغاء',
              content:
                  'هل أنت متأكد من إلغاء هذا الطلب؟',
              onPrimaryPressed: () {
                Navigator.pop(context);
                if (widget.order.id != null) {
                  setState(() {
                    _currentStatus = OrderStatus.cancelled;
                  });
                  cubit.cancelOrder(widget.order.id!);
                }
              },
            );
          },
          icon: const Icon(Icons.cancel_outlined,
              size: 20),
          label: const Text(
            'إلغاء الطلب',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
