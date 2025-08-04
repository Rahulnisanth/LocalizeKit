import 'package:ai_localizer/ai_localizer.dart';
import 'package:args/args.dart';

// Utility function to log the start of the translation process
void logTranslationSummary(
  int totalLanguages,
  int processedLanguages,
  int totalTranslated,
  Duration elapsed,
  Logger logger,
) {
  logger.info('Translation summary:');
  logger.info('   - Total languages processed: $processedLanguages/$totalLanguages');
  logger.info('   - Total strings translated: $totalTranslated');
  logger.info('   - Total time: ${elapsed.inMinutes}m ${elapsed.inSeconds % 60}s');
  logger.success('Translation process completed.');
}

// Utility function to print a banner with a title
void printBanner(String title, Logger logger) {
  final border = '=' * (title.length + 6);
  logger.info('\n$border');
  logger.info('== $title ==');
  logger.info('$border\n');
}

// Utility function to print help information
void printHelp(ArgParser parser, Logger logger) {
  logger.info('Usage: dart run arb_translator.dart -i <input_file> -l <languages> [options]');
  logger.info('\nOptions:');
  logger.info(parser.usage);
  logger.info('\nExample:');
  logger.info('  dart run arb_translator.dart -i lib/l10n/app_en.arb -l fr,de,es -b 30 -v');
}
