import 'dart:convert';
import 'dart:io';
import 'package:localize_kit/localize_kit.dart';
import 'package:dotenv/dotenv.dart';

Future<void> main(List<String> arguments) async {
  var logger = const Logger();

  printBanner('ARB File Translator', logger);

  try {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    final apiKey = env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      logger.error('❌ GEMINI_API_KEY is not set.');
      logger.info('');
      logger.info('📝 To use this tool, you need to set up your API key:');
      logger.info('');
      logger.info('1. Create a .env file in your project root');
      logger.info('2. Add your Gemini API key:');
      logger.info('   GEMINI_API_KEY=your_api_key_here');
      logger.info('');
      logger.info('🔑 Get your API key from: https://aistudio.google.com/app/apikey');
      logger.info('');
      logger.info('💡 You can also set the environment variable directly:');
      logger.info('   export GEMINI_API_KEY=your_api_key_here');
      logger.info('');
      return;
    }

    final parser = createCommandLineParser();
    final args = parser.parse(arguments);

    // Update logger with verbose flag from arguments
    logger = Logger(verbose: args['verbose'] as bool);

    // Show help and exit if requested
    if (args['help']) {
      printHelp(parser, logger);
      return;
    }

    try {
      validateCommandLineArgs(args, logger);
    } catch (e) {
      // The validation function already printed error messages
      return;
    }

    final inputPath = args['input'];
    final langs = args['languages']!.split(',').map((l) => l.trim()).toList();
    final outputDir = args['output-dir'];

    // Validate input file
    final inputFile = File(inputPath);
    if (!inputFile.existsSync()) {
      logger.error('Input file not found at $inputPath.');
      return;
    }

    final Map<String, dynamic> cleanedJSONFromSourceFile = await removeDuplicateAndReplaceCleanJSON(
      inputFile: inputFile,
      inputPath: inputPath,
    );

    // Store it as cache file
    final previousEnglishSource = await readCache(inputPath);
    logger.debug(previousEnglishSource != null ? 'Found cached source file for comparison' : 'No cached source file found - first run?');

    logger.info('Starting translation for ${langs.length} language(s): ${langs.join(', ')}');

    int totalTranslated = 0;
    int totalLanguages = 0;
    final stopwatch = Stopwatch()..start();

    for (final lang in langs) {
      try {
        // Determine output path
        final outputPath = await determineOutputPath(inputPath, lang, outputDir);
        final outputFile = File(outputPath);

        // Load existing translations if available
        final existingTranslations = await loadExistingTranslations(outputPath, logger);
        final isNewFile = !outputFile.existsSync();

        if (isNewFile) {
          logger.info('Will create a new translation file for $lang: $outputPath');
        } else {
          logger.info('Found existing translations for $lang: $outputPath');
        }

        // Find keys that need translation
        final keysToTranslate = identifyKeysToTranslate(cleanedJSONFromSourceFile, existingTranslations, previousEnglishSource, logger);

        final updatedTranslations = updateTranslationsMap(cleanedJSONFromSourceFile, existingTranslations);
        final removedKeys = findRemovedKeys(cleanedJSONFromSourceFile, existingTranslations);
        final removedMetadataKeys = findRemovedMetadataKeys(cleanedJSONFromSourceFile, existingTranslations);

        if (keysToTranslate.isEmpty) {
          if (removedKeys.isEmpty && removedMetadataKeys.isEmpty && !isNewFile) {
            logger.success('No changes needed for $lang.');
          } else {
            final updatedContent = const JsonEncoder.withIndent('  ').convert(updatedTranslations);
            await outputFile.writeAsString(updatedContent);
            logger.success('$lang localization updated at $outputPath (removed ${removedKeys.length + removedMetadataKeys.length} keys).');
          }
          continue; // Skip to next language
        }

        logger.info('   - Total to translate: ${keysToTranslate.entries.where((e) => !e.key.startsWith('@')).length} strings.');

        final translatedPartialMap = await batchTranslate(apiKey, keysToTranslate, lang, verbose: logger.verbose);
        final mergedTranslations = {...updatedTranslations, ...translatedPartialMap};
        final mergedContent = const JsonEncoder.withIndent('  ').convert(mergedTranslations);
        await outputFile.writeAsString(mergedContent);

        final translatedCount = keysToTranslate.entries.where((e) => !e.key.startsWith('@')).length;
        totalTranslated += translatedCount;
        totalLanguages++;

        logger.success(
          '$lang localization updated at $outputPath with $translatedCount strings${removedKeys.isEmpty ? '' : ' and ${removedKeys.length} removed keys'}.',
        );
      } catch (e, stackTrace) {
        logger.error('Failed to translate or save for language $lang.');
        logger.error('Error: $e');
        logger.debug('Stack trace:');
        logger.debug('$stackTrace');
      }
    }

    if (totalLanguages > 0) {
      await updateCache(inputPath, cleanedJSONFromSourceFile);
      logger.debug('Created/Updated the english source cache file');
    }

    stopwatch.stop();
    logTranslationSummary(langs.length, totalLanguages, totalTranslated, stopwatch.elapsed, logger);
  } catch (e, stackTrace) {
    logger.error('Unhandled error:');
    logger.error('$e');
    logger.debug('Stack trace:');
    logger.debug('$stackTrace');
    logger.error('Process terminated due to error.');
    exit(1);
  }
}
