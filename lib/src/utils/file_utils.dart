import 'dart:convert';
import 'dart:io';
import 'package:ai_localizer/ai_localizer.dart';
import 'package:path/path.dart' as path;

// Function to remove duplicate keys and replace cleaned JSON
Future<String> determineOutputPath(String inputPath, String lang, String? outputDir) async {
  String outputPath;
  if (outputDir != null && outputDir != '') {
    final fileName = path.basename(inputPath).replaceFirst(RegExp(r'_?en\.arb$'), '_$lang.arb');
    outputPath = path.join(outputDir, fileName);

    // Ensure output directory exists
    final directory = Directory(outputDir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  } else {
    // If no custom output directory, replace 'en' with target language in the same location
    outputPath = inputPath.replaceFirst(RegExp(r'_?en\.arb$'), '_$lang.arb');

    if (outputPath == inputPath) {
      final extension = path.extension(inputPath);
      final baseName = path.basenameWithoutExtension(inputPath);
      outputPath = path.join(path.dirname(inputPath), '${baseName}_$lang$extension');
    }
  }
  return outputPath;
}

// Function to load existing translations from a file
Future<Map<String, dynamic>> loadExistingTranslations(String filePath, Logger logger) async {
  final file = File(filePath);
  Map<String, dynamic> translations = {};
  bool fileExists = await file.exists();

  if (fileExists) {
    try {
      final content = await file.readAsString();
      translations = jsonDecode(content);
    } catch (e) {
      logger.warning('Could not read existing translations: $e');
    }
  }

  return translations;
}
