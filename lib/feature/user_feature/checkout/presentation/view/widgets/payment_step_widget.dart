import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../view_model/checkout_cubit.dart';

class PaymentStepWidget extends StatefulWidget {
  const PaymentStepWidget({super.key});

  @override
  State<PaymentStepWidget> createState() => _PaymentStepWidgetState();
}

class _PaymentStepWidgetState extends State<PaymentStepWidget> {
  late final TextEditingController _holder;
  late final TextEditingController _card;
  late final TextEditingController _cvv;
  late final CheckoutCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CheckoutCubit>();
    final d = _cubit.data;
    _holder = TextEditingController(text: d.cardHolderName);
    _card = TextEditingController(text: d.cardNumber);
    _cvv = TextEditingController(text: d.cvv);
  }

  @override
  void dispose() {
    _saveData();
    _holder.dispose();
    _card.dispose();
    _cvv.dispose();
    super.dispose();
  }

  void _saveData() {
    final d = _cubit.data;
    d.cardHolderName = _holder.text;
    d.cardNumber = _card.text;
    d.cvv = _cvv.text;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('أختار طريقة الدفع المناسبه :',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          const Text('من فضلك اختر طريقة الدفع المناسبه لك.',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          PaymentMethodsRow(
            selected: context.watch<CheckoutCubit>().data.paymentMethod,
            onSelect: (m) =>
                context.read<CheckoutCubit>().setPaymentMethod(m),
          ),
          const SizedBox(height: 20),
          _field('اسم حامل البطاقة', _holder),
          _field('رقم البطاقة', _card,
              type: TextInputType.number),
          _field('CVV', _cvv, type: TextInputType.number),
          const SizedBox(height: 8),
          _DefaultCardCheck(
            value: context.watch<CheckoutCubit>().data.defaultCard,
            onChanged: (v) {
              _cubit.data.defaultCard = v;
              _cubit.goToStep(_cubit.currentStep);
            },
          ),
        ],
      ),
    );
  }

  Widget _field(String hint, TextEditingController ctrl,
      {TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        onChanged: (_) => _saveData(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class PaymentMethodsRow extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  const PaymentMethodsRow({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  static const _methods = [
    {'key': 'tabby', 'label': 'تابي'},
    {'key': 'paypal', 'label': 'PayPal'},
    {'key': 'mastercard', 'label': 'MC'},
    {'key': 'visa', 'label': 'VISA'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _methods.map((m) {
        final isSelected = selected == m['key'];
        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => onSelect(m['key']!),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Text(m['label']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isSelected
                        ? AppColors.primary
                        : Colors.black54,
                  )),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DefaultCardCheck extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _DefaultCardCheck({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('جعل البطاقة افتراضية',
            style: TextStyle(fontSize: 13)),
        Checkbox(
          value: value,
          activeColor: AppColors.primary,
          onChanged: (v) => onChanged(v ?? false),
        ),
      ],
    );
  }
}
