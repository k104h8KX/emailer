import 'dart:io';
import 'package:dotenv/dotenv.dart';

class Env {
  // Singleton pattern
  static final Env _instance = Env._internal();
  factory Env() => _instance;

  // Variables to track initialization
  static bool _initialized = false;
  static final DotEnv _env = DotEnv();

  Env._internal();

  // Initialize - call this at the start of your app
  static void initialize() {
    if (!_initialized) {
      try {
        _env.load();
        print('Environment file loaded successfully');
        _initialized = true;
      } catch (e) {
        print('Error loading environment file: $e');
      }
    }
  }

  // Get environment variable with optional default value
  static String? get(String key, {String? defaultValue}) {
    // Make sure environment is initialized
    if (!_initialized) initialize();

    // Try dotenv first
    final value = _env[key];

    // Try system environment as fallback
    if (value == null || value.isEmpty) {
      final sysValue = Platform.environment[key];
      if (sysValue != null && sysValue.isNotEmpty) {
        return sysValue;
      }
    }

    // Return dotenv value or default
    return value ?? defaultValue;
  }

  // Debug method to check if a key exists
  static bool has(String key) {
    if (!_initialized) initialize();
    return _env[key] != null || Platform.environment[key] != null;
  }
}
