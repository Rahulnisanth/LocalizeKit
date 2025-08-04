/// AI Localizer - A powerful command-line tool for localizing Flutter applications
///
/// This package provides AI-powered translation services for Flutter ARB files.
/// It supports multiple AI models including Gemini 2.0 Flash, GPT-3.5 Turbo, and DeepSeek.
///
/// ## Features
///
/// - AI-powered translation using multiple providers
/// - Smart caching to avoid re-translating unchanged strings
/// - Batch processing to optimize API usage
/// - Preservation of ARB metadata and placeholders
/// - Support for multiple target languages
/// - Detailed logging and progress tracking
///
/// ## Usage
///
/// ```bash
/// # Install globally
/// dart pub global activate localize_kit
///
/// # Translate to multiple languages
/// localize_kit -i lib/l10n/app_en.arb -l fr,de,es,hi
///
/// # Use custom output directory
/// localize_kit -i lib/l10n/app_en.arb -l fr,de,es -o translations/
///
/// # Enable verbose logging
/// localize_kit -i lib/l10n/app_en.arb -l fr,de,es -v
/// ```
///
/// ## Setup
///
/// Create a `.env` file in your project root:
///
/// ```env
/// GEMINI_API_KEY=your_gemini_api_key_here
/// ```
///
/// Get your API key from: https://aistudio.google.com/app/apikey

library;

export 'src/api/gemini_flash.dart';
export 'src/core/constants.dart';
export 'src/utils/batch_translator.dart';
export 'src/utils/duplicate_remover.dart';
export 'src/core/logger.dart';
export 'src/utils/translation_utils.dart';
export 'src/utils/reporting_utils.dart';
export 'src/utils/arg_parser_utils.dart';
export 'src/utils/file_utils.dart';
export 'src/utils/cache_gen.dart';
