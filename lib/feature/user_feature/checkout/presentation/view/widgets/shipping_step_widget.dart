import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../view_model/checkout_cubit.dart';
import '../../../data/models/checkout_data.dart';

class ShippingStepWidget extends StatelessWidget {
  const ShippingStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CheckoutCubit>();
    final data = cubit.data;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _ShippingOption(
            title: 'الدفع عند الاستلام',
            subtitle: 'التسليم من المكان',
            price: '500 ريال',
            selected:
                data.shippingMethod == ShippingMethod.cashOnDelivery,
            onTap: () =>
                cubit.setShipping(ShippingMethod.cashOnDelivery),
          ),
          const SizedBox(height: 12),
          _ShippingOption(
            title: 'اشتري الآن وادفع لاحقاً',
            subtitle: 'يرجى تحديد طريقة الدفع',
            price: 'مجاني',
            selected:
                data.shippingMethod == ShippingMethod.buyNowPayLater,
            onTap: () =>
                cubit.setShipping(ShippingMethod.buyNowPayLater),
          ),
        ],
      ),
    );
  }
}

class _ShippingOption extends StatelessWidget {
  final String title, subtitle, price;
  final bool selected;
  final VoidCallback onTap;

  const _ShippingOption({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey[300]!,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: selected,
              activeColor: AppColors.primary,
              onChanged: (_) => onTap(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Text(price,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selected ? AppColors.primary : Colors.black54,
                )),
          ],
        ),
      ),
    );
  }
}
