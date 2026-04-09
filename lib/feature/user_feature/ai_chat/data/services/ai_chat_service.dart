import 'package:google_generative_ai/google_generative_ai.dart';

class AiChatService {
  static const _apiKey = 'AIzaSyDoDFwMOjXqgUdL1MFlMsZhkqbpNQVSC10';

  static const _systemPrompt = '''
أنت مساعد ذكي لتطبيق Spairo لقطع غيار السيارات.
أجب فقط عن أسئلة تتعلق بالتطبيق وقطع الغيار.
إذا سُئلت عن مواضيع خارج نطاق التطبيق، اعتذر بلطف.
أجب دائماً باللغة العربية وبأسلوب ودود ومختصر.

ما يمكنك المساعدة فيه:
- كيفية طلب قطعة غيار
- البحث عن منتجات
- شرح ميزات التطبيق
- حالة الطلبات
- التواصل مع الموردين
- الأسعار والمقارنة
''';

  late final GenerativeModel _model;
  late final ChatSession _chat;

  AiChatService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(_systemPrompt),
    );
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    final response = await _chat.sendMessage(Content.text(message));
    return response.text ?? 'عذراً، لم أتمكن من الرد.';
  }

  void resetChat() {
    _chat = _model.startChat();
  }
}
