import 'dart:io';
import 'dart:convert' show json, JsonEncoder;
import 'package:ai_localizer/src/core/logger.dart';

/// Cleans a JSON file by removing duplicate keys with same values
/// and throwing error if a duplicate key has different value.
Future<Map<String, dynamic>> removeDuplicateAndReplaceCleanJSON({
  required File inputFile,
  required String inputPath,
  bool dryRun = false,
}) async {
  const logger = Logger();

  logger.info('📂 Reading the input source file...');
  final rawContent = await inputFile.readAsString();

  // Parse the entire JSON at once to maintain nested structure
  Map<String, dynamic> jsonContent;
  try {
    jsonContent = json.decode(rawContent);
  } catch (e) {
    logger.error('❌ Failed to parse JSON file: $e');
    throw Exception('Invalid JSON format in $inputPath');
  }

  // Track top-level keys to find duplicates
  final Map<String, dynamic> cleaned = {};
  final removedDuplicates = <String>[];
  final conflictingDuplicates = <String>[];

  logger.info('🔍 Checking for duplicates in source file...');

  for (final entry in jsonContent.entries) {
    final key = entry.key;
    final value = entry.value;

    if (cleaned.containsKey(key)) {
      // We have a duplicate key
      if (cleaned[key] == value) {
        // Exact duplicate — remove it
        removedDuplicates.add(key);
        continue;
      } else {
        // Duplicate key with different value — throw error
        conflictingDuplicates.add(key);
        throw Exception(
          '❌ Error: Duplicate key "$key" found with conflicting values:\n'
          '   → First: "${cleaned[key]}"\n'
          '   → Second: "$value"\n'
          '   Each key in the JSON file must be unique.\n'
          '   Please resolve the conflict manually in $inputPath',
        );
      }
    }

    // Store unique entry
    cleaned[key] = value;
  }

  // Show summary of the file
  final stringCount = cleaned.entries.where((e) => !e.key.startsWith('@')).length;
  final metadataCount = cleaned.entries.where((e) => e.key.startsWith('@')).length;

  logger.info('📊 Source file: $inputPath');
  logger.info('   - ${cleaned.length + removedDuplicates.length} total entries');
  logger.info('   - $stringCount translatable strings');
  logger.info('   - $metadataCount metadata entries');

  // Summary of cleanup
  if (removedDuplicates.isNotEmpty) {
    logger.success('🧹 Found and removed ${removedDuplicates.length} exact duplicate entries: ${removedDuplicates.join(', ')}');
  } else {
    logger.success('✅ No exact duplicates found in source file');
  }

  // Write cleaned file if not dry run
  if (removedDuplicates.isNotEmpty && !dryRun) {
    final cleanedJsonString = const JsonEncoder.withIndent('  ').convert(cleaned);

    // Overwrite input file
    await inputFile.writeAsString(cleanedJsonString);
    logger.success('✅ Cleaned up input file saved at $inputPath');
  } else if (dryRun && removedDuplicates.isNotEmpty) {
    logger.success('🔍 Dry run: Input file would be cleaned (${removedDuplicates.length} duplicates removed)');
  }

  return cleaned;
}
