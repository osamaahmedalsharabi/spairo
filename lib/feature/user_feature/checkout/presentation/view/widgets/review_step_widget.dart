import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/checkout_cubit.dart';

class ReviewStepWidget extends StatelessWidget {
  final double productPrice;
  final VoidCallback onEditPayment;
  final VoidCallback onEditAddress;

  const ReviewStepWidget({
    super.key,
    required this.productPrice,
    required this.onEditPayment,
    required this.onEditAddress,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.watch<CheckoutCubit>().data;
    final delivery = data.shippingCost;
    final total = productPrice + delivery;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ملخص الطلب :',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          _SummaryRow('المجموع الفرعي :', '$productPrice ريال'),
          _SummaryRow('التوصيل :', '${delivery}ريال'),
          const Divider(height: 24),
          _SummaryRow('الكلي', '$total ريال', bold: true),
          const SizedBox(height: 8),
          const Text('يرجي تأكيد طلبك',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          const Divider(height: 24),
          _EditableSection(
            title: 'وسيلة الدفع',
            value: data.paymentMethod ?? 'غير محدد',
            subtitle: data.referenceNumber.isNotEmpty 
                ? 'الرقم المرجعي: ${data.referenceNumber}' 
                : '',
            onEdit: onEditPayment,
          ),
          const Divider(height: 24),
          _EditableSection(
            title: 'عنوان التوصيل',
            value: data.fullAddress,
            icon: Icons.location_on_outlined,
            onEdit: onEditAddress,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _SummaryRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14)),
          Text(value, style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14)),
        ],
      ),
    );
  }
}

class _EditableSection extends StatelessWidget {
  final String title, value;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onEdit;
  const _EditableSection({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: onEdit,
              child: Row(
                children: [
                  const Text('تعديل',
                      style: TextStyle(
                          color: Colors.grey, fontSize: 12)),
                  const SizedBox(width: 4),
                  Icon(Icons.edit, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (icon != null)
          Row(children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Expanded(child: Text(value,
                style: const TextStyle(fontSize: 13))),
          ])
        else
          Text(value, style: const TextStyle(fontSize: 13)),
        if (subtitle != null && subtitle!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(subtitle!,
                style: const TextStyle(
                    color: Colors.grey, fontSize: 12)),
          ),
      ],
    );
  }
}
