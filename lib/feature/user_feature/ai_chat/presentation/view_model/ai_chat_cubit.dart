import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/chat_message.dart';
import '../../data/services/ai_chat_service.dart';

part 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  final AiChatService _service;

  AiChatCubit(this._service) : super(AiChatInitial());

  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages =>
      List.unmodifiable(_messages);

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final userMsg = ChatMessage(text: text, isUser: true);
    _messages.add(userMsg);
    emit(AiChatLoaded(List.from(_messages), isTyping: true));

    try {
      final reply = await _service.sendMessage(text);
      final aiMsg = ChatMessage(text: reply, isUser: false);
      _messages.add(aiMsg);
      emit(AiChatLoaded(List.from(_messages)));
    } catch (e) {
      final errMsg = ChatMessage(
        text: 'عذراً حدث خطأ، حاول مرة أخرى.',
        isUser: false,
      );
      _messages.add(errMsg);
      emit(AiChatLoaded(List.from(_messages)));
    }
  }

  void clearChat() {
    _messages.clear();
    _service.resetChat();
    emit(AiChatInitial());
  }
}
