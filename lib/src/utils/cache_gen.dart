import 'dart:convert';
import 'dart:io';
import 'package:localize_kit/src/core/logger.dart';
import 'package:path/path.dart' as path;

const logger = Logger();

// Function to update the cache with non-metadata entries
Future<void> updateCache(String sourcePath, Map<String, dynamic> sourceData) async {
  final cacheFilePath = _getCacheFilePath(sourcePath);
  final cacheDir = Directory(path.dirname(cacheFilePath));

  // Create cache directory if it doesn't exist
  if (!cacheDir.existsSync()) {
    await cacheDir.create(recursive: true);
  }

  // Extract only non-metadata entries (keys that don't start with @)
  final nonMetadataEntries = <String, dynamic>{};
  sourceData.forEach((key, value) {
    if (!key.startsWith('@')) {
      nonMetadataEntries[key] = value;
    }
  });

  // Write cache file with only the key-value pairs (no metadata)
  final cacheFile = File(cacheFilePath);
  final cacheContent = const JsonEncoder.withIndent('  ').convert(nonMetadataEntries);
  await cacheFile.writeAsString(cacheContent);
}

// Function to read the cache
Future<Map<String, dynamic>?> readCache(String sourcePath) async {
  final cacheFilePath = _getCacheFilePath(sourcePath);
  final cacheFile = File(cacheFilePath);

  if (cacheFile.existsSync()) {
    try {
      final content = await cacheFile.readAsString();
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      logger.warning('Failed to read cache file: $e');
      return null;
    }
  }

  return null;
}

// Function to get the cache file path
String _getCacheFilePath(String sourcePath) {
  final sourceFile = path.basename(sourcePath);
  final cacheDir = path.join(path.dirname(sourcePath), '.cache');
  return path.join(cacheDir, sourceFile);
}
