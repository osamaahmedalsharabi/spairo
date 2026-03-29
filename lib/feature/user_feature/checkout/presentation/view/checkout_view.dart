import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/submit_order_cubit.dart';
import '../view_model/checkout_cubit.dart';
import 'widgets/checkout_step_indicator.dart';
import 'widgets/shipping_step_widget.dart';
import 'widgets/address_step_widget.dart';
import 'widgets/payment_step_widget.dart';
import 'widgets/review_step_widget.dart';

class CheckoutView extends StatelessWidget {
  final PartOrderModel order;
  const CheckoutView({super.key, required this.order});

  static const _titles = ['الشحن', 'العنوان', 'الدفع', 'المراجعة'];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CheckoutCubit()),
        BlocProvider(
            create: (_) => sl<SubmitOrderCubit>()),
      ],
      child: Builder(
        builder: (ctx) {
          return BlocConsumer<SubmitOrderCubit, SubmitOrderState>(
            listener: (context, state) {
              if (state is SubmitOrderSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('تم تأكيد الطلب بنجاح'),
                      backgroundColor: Colors.green),
                );
                Navigator.pop(context);
              } else if (state is SubmitOrderFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red),
                );
              }
            },
            builder: (context, submitState) {
              return BlocBuilder<CheckoutCubit, CheckoutState>(
                builder: (context, state) {
                  final step = (state as CheckoutStep).step;
                  final cubit = context.read<CheckoutCubit>();
                  return Scaffold(
                    backgroundColor: AppColors.backgroundLight,
                    appBar: AppBar(
                      backgroundColor: AppColors.backgroundLight,
                      elevation: 0,
                      centerTitle: true,
                      title: Text(_titles[step],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Colors.black),
                        onPressed: () {
                          if (step > 0) {
                            cubit.previousStep();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    body: Column(
                      children: [
                        CheckoutStepIndicator(currentStep: step),
                        Expanded(
                          child: _buildStep(context, step, cubit),
                        ),
                        _BottomButton(
                          step: step,
                          isLoading: submitState is SubmitOrderLoading,
                          onTap: () => _onNext(context, step, cubit),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStep(BuildContext ctx, int step, CheckoutCubit cubit) {
    switch (step) {
      case 0:
        return const ShippingStepWidget();
      case 1:
        return const AddressStepWidget();
      case 2:
        return const PaymentStepWidget();
      case 3:
        return ReviewStepWidget(
          productPrice: order.productPrice ?? 0,
          onEditPayment: () => cubit.goToStep(2),
          onEditAddress: () => cubit.goToStep(1),
        );
      default:
        return const SizedBox();
    }
  }

  void _onNext(BuildContext context, int step, CheckoutCubit cubit) {
    if (step == 0 && cubit.data.shippingMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('الرجاء اختيار طريقة الشحن'),
            backgroundColor: Colors.red),
      );
      return;
    }
    if (step == 1) {
      final d = cubit.data;
      if (d.fullName.isEmpty || d.address.isEmpty || d.city.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('الرجاء تعبئة حقول العنوان المطلوبة'),
              backgroundColor: Colors.red),
        );
        return;
      }
    }
    if (step < 3) {
      cubit.nextStep();
    } else {
      _submitOrder(context, cubit);
    }
  }

  void _submitOrder(BuildContext context, CheckoutCubit cubit) {
    final d = cubit.data;
    final finalOrder = PartOrderModel(
      uid: order.uid,
      orderNumber: order.orderNumber,
      status: order.status,
      companyName: order.companyName,
      companyImage: order.companyImage,
      carName: order.carName,
      carImage: order.carImage,
      categoryName: order.categoryName,
      categoryImage: order.categoryImage,
      carYear: order.carYear,
      condition: order.condition,
      partNumber: order.partNumber,
      partName: order.partName,
      details:
          '${order.details}\n\nالشحن: ${d.shippingLabel}\nالعنوان: ${d.fullAddress}\nالدفع: ${d.paymentMethod ?? "غير محدد"}',
      orderImage: order.orderImage,
      createdAt: order.createdAt,
      supplierId: order.supplierId,
      productId: order.productId,
      productPrice: order.productPrice,
      senderType: order.senderType,
      shippingMethod: d.shippingLabel,
      deliveryAddress: d.fullAddress,
      paymentMethod: d.paymentMethod,
    );
    context.read<SubmitOrderCubit>().submitOrder(finalOrder, null);
  }
}

class _BottomButton extends StatelessWidget {
  final int step;
  final bool isLoading;
  final VoidCallback onTap;
  const _BottomButton({
    required this.step,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  step < 3
                      ? (step == 2 ? 'تأكيد & استمرار' : 'التالي')
                      : 'تأكيد الطلب',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
