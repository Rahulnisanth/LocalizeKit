import 'package:localize_kit/localize_kit.dart';
import 'package:args/args.dart';

ArgParser createCommandLineParser() {
  return ArgParser()
    ..addOption('input', abbr: 'i', help: 'Path to input .arb file (English source)')
    ..addOption('languages', abbr: 'l', help: 'Comma-separated language codes (e.g., hi,fr,de,es)')
    ..addOption('output-dir', abbr: 'o', help: 'Custom output directory (default: same as input)')
    ..addFlag('verbose', abbr: 'v', help: 'Show detailed logs', defaultsTo: false)
    ..addFlag('help', abbr: 'h', help: 'Show this help message', defaultsTo: false);
}

// Function to print help information
void validateCommandLineArgs(ArgResults args, Logger logger) {
  final inputPath = args['input'];
  final langs = args['languages']?.split(',').map((l) => l.trim()) ?? [];

  if (inputPath == null || inputPath.isEmpty) {
    logger.error('Input file path is required.');
    printHelp(createCommandLineParser(), logger);
    throw Exception('Missing input path argument');
  }

  if (langs.isEmpty) {
    logger.error('At least one target language is required.');
    printHelp(createCommandLineParser(), logger);
    throw Exception('Missing target languages argument');
  }
}
