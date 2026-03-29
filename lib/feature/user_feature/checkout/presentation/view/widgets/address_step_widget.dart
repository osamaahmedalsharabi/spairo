import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../view_model/checkout_cubit.dart';

class AddressStepWidget extends StatefulWidget {
  const AddressStepWidget({super.key});

  @override
  State<AddressStepWidget> createState() => _AddressStepWidgetState();
}

class _AddressStepWidgetState extends State<AddressStepWidget> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _city;
  late final TextEditingController _apartment;
  late final CheckoutCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CheckoutCubit>();
    final d = _cubit.data;
    _name = TextEditingController(text: d.fullName);
    _email = TextEditingController(text: d.email);
    _address = TextEditingController(text: d.address);
    _city = TextEditingController(text: d.city);
    _apartment = TextEditingController(text: d.apartment);
  }

  @override
  void dispose() {
    _saveData();
    _name.dispose();
    _email.dispose();
    _address.dispose();
    _city.dispose();
    _apartment.dispose();
    super.dispose();
  }

  void _saveData() {
    final d = _cubit.data;
    d.fullName = _name.text;
    d.email = _email.text;
    d.address = _address.text;
    d.city = _city.text;
    d.apartment = _apartment.text;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CheckoutCubit>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _field('الاسم كامل', _name),
          _field('البريد الإلكتروني', _email,
              type: TextInputType.emailAddress),
          _field('العنوان', _address),
          _field('المدينة', _city),
          _field('رقم الطابق , رقم الشقة..', _apartment),
          const SizedBox(height: 8),
          _SaveSwitch(
            value: cubit.data.saveAddress,
            onChanged: (v) {
              cubit.data.saveAddress = v;
              cubit.goToStep(cubit.currentStep);
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

class _SaveSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SaveSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('حفظ العنوان',
            style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(width: 8),
        Switch(
          value: value,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
