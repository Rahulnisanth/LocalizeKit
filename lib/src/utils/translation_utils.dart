import 'package:localize_kit/localize_kit.dart';

// Function to identify keys that need translation
Map<String, dynamic> identifyKeysToTranslate(
  Map<String, dynamic> cleanedSource,
  Map<String, dynamic> existingTranslations,
  Map<String, dynamic>? previousEnglishSource,
  Logger logger,
) {
  final keysToTranslate = <String, dynamic>{};
  int newKeys = 0;
  int modifiedValues = 0;
  int modifiedMetadata = 0;
  int unchangedKeys = 0;

  // Process each key in the cleaned source
  cleanedSource.forEach((key, value) {
    if (key.startsWith('@')) return;

    if (value is String) {
      final previousEnglishValue = previousEnglishSource?[key];

      // Detect source changes
      if (previousEnglishSource != null && previousEnglishValue != null && previousEnglishValue != value) {
        logger.warning('📝 The value for "$key" has changed. (was: "$previousEnglishValue", now: "$value")');
        keysToTranslate[key] = value;
        if (cleanedSource.containsKey('@$key')) {
          keysToTranslate['@$key'] = cleanedSource['@$key'];
        }
        modifiedValues++;
      }

      final bool needsTranslation = !existingTranslations.containsKey(key);
      final hasMetadataChanges = cleanedSource.containsKey('@$key') &&
          existingTranslations.containsKey('@$key') &&
          !mapEquals(existingTranslations['@$key'], cleanedSource['@$key']);

      if (needsTranslation || hasMetadataChanges) {
        keysToTranslate[key] = value;

        if (cleanedSource.containsKey('@$key')) {
          keysToTranslate['@$key'] = cleanedSource['@$key'];
        }

        if (!existingTranslations.containsKey(key)) {
          newKeys++;
        }

        if (hasMetadataChanges) {
          modifiedMetadata++;
        }
      } else {
        unchangedKeys++;
      }
    }
  });

  // Log statistics
  logger.info('Translation summary:');
  logger.info('   - New keys: $newKeys');
  logger.info('   - Modified values: $modifiedValues');
  logger.info('   - Modified metadata: $modifiedMetadata');
  logger.info('   - Unchanged keys: $unchangedKeys');
  logger.info('   - Total to translate: ${keysToTranslate.entries.where((e) => !e.key.startsWith('@')).length} strings.');

  return keysToTranslate;
}

// Function to update the translations map
Map<String, dynamic> updateTranslationsMap(
  Map<String, dynamic> cleanedSource,
  Map<String, dynamic> existingTranslations,
) {
  final updatedTranslations = <String, dynamic>{};

  cleanedSource.forEach((key, value) {
    if (existingTranslations.containsKey(key)) {
      updatedTranslations[key] = existingTranslations[key];
    }
  });

  return updatedTranslations;
}

List<String> findRemovedKeys(
  Map<String, dynamic> cleanedSource,
  Map<String, dynamic> existingTranslations,
) {
  return existingTranslations.keys.where((key) => !cleanedSource.containsKey(key) && !key.startsWith('@')).toList();
}

List<String> findRemovedMetadataKeys(
  Map<String, dynamic> cleanedSource,
  Map<String, dynamic> existingTranslations,
) {
  return existingTranslations.keys.where((key) => key.startsWith('@') && !cleanedSource.containsKey(key)).toList();
}

// Utility function to compare metadata objects
bool mapEquals(dynamic a, dynamic b) {
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;

  if (a is Map && b is Map) {
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;

      final aValue = a[key];
      final bValue = b[key];

      if (aValue is Map && bValue is Map) {
        if (!mapEquals(aValue, bValue)) return false;
      } else if (aValue != bValue) {
        return false;
      }
    }

    return true;
  }

  return a == b;
}
