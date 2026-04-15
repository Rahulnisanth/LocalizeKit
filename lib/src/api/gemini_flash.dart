import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localize_kit/src/core/constants.dart';

// Function to call Gemini 2.5 Flash API for translation
/// Translates the given ARB content to the specified language using Gemini 2.5 Flash's.
/// Returns the translated content as a JSON string.
Future<String> translateWithGemini(String apiKey, String promptHeader, String promptBody, String jsonContent, String targetLang) async {
  final uri = Uri.parse('$GEMINI_BASE_URL?key=$apiKey');

  final prompt = '''$promptHeader $targetLang. $promptBody $jsonContent''';

  // Create the request payload
  final requestBody = jsonEncode({
    'contents': [
      {
        'parts': [
          {'text': prompt},
        ],
      },
    ],
    'generationConfig': {'temperature': 0.2, 'topP': 0.8, 'topK': 40},
  });

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final candidates = jsonResponse['candidates'] as List;
      if (candidates.isNotEmpty) {
        final parts = candidates[0]['content']['parts'] as List;
        if (parts.isNotEmpty) {
          final translatedText = parts[0]['text'];

          // Extract just the JSON part from the response
          final jsonStart = translatedText.indexOf('{');
          final jsonEnd = translatedText.lastIndexOf('}') + 1;

          if (jsonStart >= 0 && jsonEnd > jsonStart) {
            return translatedText.substring(jsonStart, jsonEnd);
          } else {
            throw Exception('Unable to extract JSON from response');
          }
        }
      }
      throw Exception('No valid content in API response');
    } else {
      throw Exception('API Error (${response.statusCode}): ${response.body}');
    }
  } catch (e) {
    throw Exception('API Error: $e');
  }
}
