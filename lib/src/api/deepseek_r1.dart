import 'dart:convert';
import 'package:ai_localizer/src/core/constants.dart';
import 'package:http/http.dart' as http;

// Function to call DeepSeek API for translation
/// Translates the given ARB content to the specified language using DeepSeek's API.
/// Returns the translated content as a JSON string.
Future<String> translateWithDeepSeek(String apiKey, String arbContent, String langCode) async {
  final prompt = '''$PROMPT_HEADER $langCode. $PROMPT_BODY $arbContent''';

  final res = await http.post(
    Uri.parse(DEEPSEEK_BASE_URL),
    headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
    body: jsonEncode({
      'model': 'deepseek-chat',
      'messages': [
        {'role': 'user', 'content': prompt},
      ],
      'stream': false,
    }),
  );

  if (res.statusCode != 200) {
    throw Exception('DeepSeek API call failed: ${res.statusCode} ${res.body}');
  }

  final data = jsonDecode(res.body);
  if (data['choices'] == null || data['choices'].isEmpty) {
    throw Exception('Invalid response from DeepSeek: ${res.body}');
  }

  final content = data['choices'][0]['message']['content'];
  return content ?? '{}';
}
