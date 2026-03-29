import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class AiChatInputWidget extends StatefulWidget {
  final ValueChanged<String> onSend;
  const AiChatInputWidget({super.key, required this.onSend});

  @override
  State<AiChatInputWidget> createState() => _AiChatInputWidgetState();
}

class _AiChatInputWidgetState extends State<AiChatInputWidget> {
  final _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _send,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.send,
                  color: AppColors.primary, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              textDirection: TextDirection.rtl,
              onSubmitted: (_) => _send(),
              decoration: InputDecoration(
                hintText: 'كيف يمكننا مساعدتك؟',
                hintStyle: const TextStyle(
                    color: Colors.grey, fontSize: 14),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
