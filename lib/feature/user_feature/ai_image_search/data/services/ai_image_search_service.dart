import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiImageSearchService {
  static const _apiKey = 'AIzaSyDoDFwMOjXqgUdL1MFlMsZhkqbpNQVSC10';

  static const _systemPrompt = '''
أنت خبير في قطع غيار السيارات.
سيتم تزويدك بصورة. مهمتك تحديد ما إذا كانت الصورة لقطعة غيار سيارة أم لا.
إذا كانت قطعة غيار سيارة، استخرج اسمها باللغة العربية، وإذا ظهر رقم القطعة بوضوح استخرجه أيضاً.
يجب أن ترجع الرد فقط بصيغة JSON خالية من أي نص إضافي، بالتنسيق التالي:
{
  "isCarPart": true/false,
  "partName": "اسم القطعة أو القيمة null",
  "partNumber": "رقم القطعة أو القيمة null"
}
''';

  late final GenerativeModel _model;

  AiImageSearchService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(_systemPrompt),
    );
  }

  Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await _model.generateContent([
        Content.multi([
          TextPart('حلل هذه الصورة وأرجع لي تفاصيلها بملف JSON فقط.'),
          imagePart,
        ]),
      ]);

      final text = response.text ?? '';
      // Clean up markdown formatting if exists
      String jsonStr = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(jsonStr);
    } catch (e) {
      log(e.toString());
      throw Exception('فشل في تحليل الصورة: ${e.toString()}');
    }
  }

  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final request = await HttpClient().getUrl(Uri.parse(url));
      final response = await request.close();
      final builder = BytesBuilder();
      await for (var data in response) {
        builder.add(data);
      }
      return builder.takeBytes();
    } catch (e) {
      log('Failed to download image = $url', error: e);
      return null;
    }
  }

  Future<List<String>> matchWithImages(
    File userImage,
    Map<String, String> candidateImages,
  ) async {
    try {
      final userImageBytes = await userImage.readAsBytes();
      final userImagePart = DataPart('image/jpeg', userImageBytes);

      final List<Part> parts = [
        TextPart('هذه صورة القطعة التي يريدها المستخدم (صورة المستخدم):'),
        userImagePart,
        TextPart(
          'الآن سأعرض عليك مجموعة من المنتجات المتاحة لدينا، كل منتج يسبقه مفتاح ID الخاص به ومتبوعاً بصورته. مهمتك: حدد ما هو المنتج الذي يظهر في صورة المستخدم. ابحث عن أي منتج بشبه صورة المستخدم أو يطابقها. أرجع الجواب كمصفوفة JSON تحتوي فقط على معرفات ID للمنتجات المطابقة بصرياً. مثال: [ "id1" ]. وإذا لم يكن هناك تطابق أرجع []. الرد يجب أن يكون JSON فقط:',
        ),
      ];

      // Download images concurrently for speed and robustness
      final List<Future<MapEntry<String, Uint8List?>>> futures = candidateImages
          .entries
          .map((entry) async {
            if (entry.value.isEmpty) return MapEntry(entry.key, null);
            final bytes = await _downloadImage(entry.value);
            return MapEntry(entry.key, bytes);
          })
          .toList();

      final results = await Future.wait(futures);

      for (var result in results) {
        if (result.value != null) {
          parts.add(TextPart('ID: ${result.key}'));
          parts.add(DataPart('image/jpeg', result.value!));
        }
      }

      final response = await _model.generateContent([Content.multi(parts)]);
      final text = response.text ?? '[]';

      String jsonStr = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      int startIndex = jsonStr.indexOf('[');
      int endIndex = jsonStr.lastIndexOf(']');
      if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
        jsonStr = jsonStr.substring(startIndex, endIndex + 1);
      } else {
        jsonStr = '[]';
      }

      final List<dynamic> decoded = jsonDecode(jsonStr);
      return decoded.map((e) => e.toString().trim()).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
