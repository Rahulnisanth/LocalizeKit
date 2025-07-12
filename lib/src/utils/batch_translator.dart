import 'dart:convert';
import 'dart:math';
import 'package:ai_localizer/ai_localizer.dart';

// Batch translation function to handle large sets of strings
Future<Map<String, dynamic>> batchTranslate(
  String apiKey,
  Map<String, dynamic> stringsToTranslate,
  String targetLang, {
  int batchSize = 20,
  bool verbose = false,
}) async {
  var logger = const Logger();
  // Extract only normal strings for translation (no metadata)
  final normalStrings = <String, String>{};

  stringsToTranslate.forEach((key, value) {
    if (!key.startsWith('@') && value is String) {
      normalStrings[key] = value;
    }
  });

  // Get string keys in a list for batching
  final stringKeys = normalStrings.keys.toList();
  final resultMap = <String, dynamic>{};

  // Process in batches
  for (int i = 0; i < stringKeys.length; i += batchSize) {
    final endIndex = min(i + batchSize, stringKeys.length);
    final batchKeys = stringKeys.sublist(i, endIndex);

    // Create a batch with just the subset of strings (no metadata)
    final batchStrings = <String, String>{};
    for (final key in batchKeys) {
      batchStrings[key] = normalStrings[key]!;
    }

    logger.info(
        '🔄 Translating batch ${(i ~/ batchSize) + 1} of ${(stringKeys.length / batchSize).ceil()} to $targetLang (${batchKeys.length} strings)');

    // Encode just this batch
    final batchJson = JsonEncoder.withIndent('  ').convert(batchStrings);

    // Send for translation
    try {
      final translatedBatch = await translateWithGemini(apiKey, PROMPT_HEADER, PROMPT_BODY, batchJson, targetLang);

      // Parse and merge results
      final translatedMap = jsonDecode(translatedBatch);
      resultMap.addAll(translatedMap);

      logger.success('👍 Batch ${(i ~/ batchSize) + 1} completed successfully');
    } catch (e) {
      logger.error('⚠️ Warning: Failed to translate batch: $e');
      for (final key in batchKeys) {
        resultMap[key] = '[TRANSLATION FAILED] ${normalStrings[key]}';
      }
    }

    // Add a small delay between batches to avoid rate limiting
    if (endIndex < stringKeys.length) {
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  return resultMap;
}
