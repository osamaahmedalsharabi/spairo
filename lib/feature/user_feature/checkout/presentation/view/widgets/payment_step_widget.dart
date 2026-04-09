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
  late final TextEditingController _ref;
  late final CheckoutCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CheckoutCubit>();
    final d = _cubit.data;
    _ref = TextEditingController(text: d.referenceNumber);
  }

  @override
  void dispose() {
    _saveData();
    _ref.dispose();
    super.dispose();
  }

  void _saveData() {
    final d = _cubit.data;
    d.referenceNumber = _ref.text;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أختار طريقة الدفع المناسبه :',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          const Text(
            'من فضلك اختر طريقة الدفع المناسبه لك.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          PaymentMethodsRow(
            selected: context.watch<CheckoutCubit>().data.paymentMethod,
            onSelect: (m) => context.read<CheckoutCubit>().setPaymentMethod(m),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          _field('الرقم المرجعي', _ref, type: TextInputType.number),
        ],
      ),
    );
  }

  Widget _field(
    String hint,
    TextEditingController ctrl, {
    TextInputType? type,
  }) {
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
            horizontal: 16,
            vertical: 14,
          ),
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
    {'key': 'jawali', 'label': 'جوالي'},
    {'key': 'Jaib', 'label': 'جيب'},
    {'key': 'onecash', 'label': 'وان كاش'},
    {'key': 'floosak', 'label': 'فلوسك'},
    {'key': 'mahfathati', 'label': 'محفظتي'},
    {'key': 'mobilemoney', 'label': 'موبايل موني'},
    {'key': 'kuraimi', 'label': 'الكريمي'},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _methods.map((m) {
        final isSelected = selected == m['key'];
        return GestureDetector(
          onTap: () => onSelect(m['key']!),
          child: Container(
            width: (MediaQuery.of(context).size.width - 64) / 3, // 3 columns
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withAlpha(20)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Text(
              m['label']!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
