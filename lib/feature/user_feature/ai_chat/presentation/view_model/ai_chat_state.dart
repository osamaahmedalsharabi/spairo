part of 'ai_chat_cubit.dart';

abstract class AiChatState {}

class AiChatInitial extends AiChatState {}

class AiChatLoaded extends AiChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  AiChatLoaded(this.messages, {this.isTyping = false});
}
