import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../data/services/ai_chat_service.dart';
import '../view_model/ai_chat_cubit.dart';
import 'widgets/ai_chat_empty_widget.dart';
import 'widgets/ai_chat_suggestions_widget.dart';
import 'widgets/ai_chat_bubble_widget.dart';
import 'widgets/ai_chat_input_widget.dart';

class AiChatView extends StatelessWidget {
  const AiChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AiChatCubit(AiChatService()),
      child: const _AiChatBody(),
    );
  }
}

class _AiChatBody extends StatelessWidget {
  const _AiChatBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('مساعد Spairo ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                )),
            Text('(نسخة تجريبية)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                )),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios,
              color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 12),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_outlined,
                color: AppColors.primary, size: 22),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildChatArea(context)),
          _buildDisclaimer(),
        ],
      ),
    );
  }

  Widget _buildChatArea(BuildContext context) {
    return BlocBuilder<AiChatCubit, AiChatState>(
      builder: (context, state) {
        if (state is AiChatInitial) {
          return Column(
            children: [
              const Spacer(),
              const AiChatEmptyWidget(),
              const SizedBox(height: 24),
              AiChatSuggestionsWidget(
                onTap: (text) => context
                    .read<AiChatCubit>()
                    .sendMessage(text),
              ),
              const Spacer(),
              AiChatInputWidget(
                onSend: (text) => context
                    .read<AiChatCubit>()
                    .sendMessage(text),
              ),
            ],
          );
        }
        if (state is AiChatLoaded) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16),
                  itemCount: state.messages.length +
                      (state.isTyping ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i == state.messages.length &&
                        state.isTyping) {
                      return const _TypingIndicator();
                    }
                    return AiChatBubbleWidget(
                        message: state.messages[i]);
                  },
                ),
              ),
              AiChatInputWidget(
                onSend: (text) => context
                    .read<AiChatCubit>()
                    .sendMessage(text),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: 6, horizontal: 16),
      color: AppColors.primary.withOpacity(0.08),
      child: const Text(
        'قد تحتوي بعض الإجابات على أخطاء للتأكد يرجى التواصل مع خدمة العملاء',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          color: Colors.red,
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            const Text('يكتب...',
                style: TextStyle(
                    color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
