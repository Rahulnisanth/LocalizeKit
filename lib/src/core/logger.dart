// ignore_for_file: avoid_print

/// Simple logger with support for different log levels and colored output
class Logger {
  final bool verbose;

  const Logger({this.verbose = false});

  /// Log an informational message
  void info(String message) {
    print('\x1B[34m[INFO]\x1B[0m $message');
  }

  /// Log a debug message (only shown in verbose mode)
  void debug(String message) {
    if (verbose) {
      print('\x1B[36m[DEBUG]\x1B[0m $message');
    }
  }

  /// Log an error message
  void error(String message) {
    print('\x1B[31m[ERROR]\x1B[0m $message');
  }

  /// Log a warning message
  void warning(String message) {
    print('\x1B[33m[WARNING]\x1B[0m $message');
  }

  /// Log a success message
  void success(String message) {
    print('\x1B[32m[SUCCESS]\x1B[0m $message');
  }
}
