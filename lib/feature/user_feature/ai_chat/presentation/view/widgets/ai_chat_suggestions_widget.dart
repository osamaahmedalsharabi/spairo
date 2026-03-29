import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class AiChatSuggestionsWidget extends StatelessWidget {
  final ValueChanged<String> onTap;
  const AiChatSuggestionsWidget({super.key, required this.onTap});

  static const _suggestions = [
    'كيف اطلب منتج؟',
    'كيف ابحث عن قطعة غيار؟',
    'كيف أقارن الأسعار؟',
    'كيف أتواصل مع مورد؟',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: _suggestions.map((s) {
          return GestureDetector(
            onTap: () => onTap(s),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(s,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          );
        }).toList(),
      ),
    );
  }
}
