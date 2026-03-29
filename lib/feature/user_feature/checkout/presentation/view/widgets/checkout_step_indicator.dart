import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class CheckoutStepIndicator extends StatelessWidget {
  final int currentStep;
  const CheckoutStepIndicator({super.key, required this.currentStep});

  static const _labels = ['الشحن', 'العنوان', 'الدفع', 'المراجعة'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (i) {
          final done = i < currentStep;
          final active = i == currentStep;
          return _StepDot(
            label: _labels[i],
            index: i + 1,
            done: done,
            active: active,
          );
        }),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final String label;
  final int index;
  final bool done;
  final bool active;
  const _StepDot({
    required this.label,
    required this.index,
    required this.done,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (done)
            const Icon(Icons.check_circle,
                color: AppColors.primary, size: 22)
          else
            CircleAvatar(
              radius: 11,
              backgroundColor:
                  active ? AppColors.primary : Colors.grey[300],
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 12,
                  color: active ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight:
                  active || done ? FontWeight.bold : FontWeight.normal,
              color: active || done
                  ? AppColors.primary
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
