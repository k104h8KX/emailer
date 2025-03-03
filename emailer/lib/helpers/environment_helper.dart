import 'package:dotenv/dotenv.dart';

class Env {
  static final Env _instance = Env._internal();
  factory Env() => _instance;
  Env._internal();

  // The actual environment variables
  static final DotEnv _env = DotEnv()..load();

  // Getter to safely access variables
  static String? get(String key) => _env[key];
}
