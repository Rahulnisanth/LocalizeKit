import 'dart:convert';
import 'package:ai_localizer/src/core/constants.dart';
import 'package:http/http.dart' as http;

// Function to call OpenAI API for translation
/// Translates the given ARB content to the specified language using OpenAI's GPT-3.5 API.
/// Returns the translated content as a JSON string.
Future<String> translateWithGPT(String apiKey, String arbContent, String langCode) async {
  final prompt = '''$PROMPT_HEADER $langCode. $PROMPT_BODY $arbContent''';

  final res = await http.post(
    Uri.parse(OPENAI_BASE_URL),
    headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
    body: jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': prompt},
      ],
      'temperature': 0.3,
    }),
  );

  if (res.statusCode != 200) {
    throw Exception('OpenAI API call failed: ${res.statusCode} ${res.body}');
  }

  final data = jsonDecode(res.body);
  if (data['choices'] == null || data['choices'].isEmpty) {
    throw Exception('Invalid response from OpenAI: ${res.body}');
  }

  final content = data['choices'][0]['message']['content'];
  return content ?? '{}';
}
