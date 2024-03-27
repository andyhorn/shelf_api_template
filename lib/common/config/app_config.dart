import 'package:dotenv/dotenv.dart';

class _MissingConfigValueError extends Error {
  _MissingConfigValueError(this.key);

  final String key;

  @override
  String toString() => 'Missing config value for key: $key';
}

extension DotEnvExt on DotEnv {
  String getOrThrow(String key) {
    return getOrElse(key, () => throw _MissingConfigValueError(key));
  }
}

final class AppConfig {
  static AppConfig? _instance;

  factory AppConfig() {
    _instance ??= AppConfig.init();
    return _instance!;
  }

  AppConfig.init() {
    final env = DotEnv(includePlatformEnvironment: true)..load();

    dbName = env.getOrThrow('DB_NAME');
    dbHost = env.getOrThrow('DB_HOST');
    dbPort = int.parse(env.getOrThrow('DB_PORT'));
    dbUser = env.getOrThrow('DB_USER');
    dbPassword = env.getOrThrow('DB_PASSWORD');

    supabase = SupabaseConfig._init(env);
  }

  late final String dbName;
  late final String dbHost;
  late final int dbPort;
  late final String dbUser;
  late final String dbPassword;

  late final SupabaseConfig supabase;
}

final class SupabaseConfig {
  static SupabaseConfig? _instance;

  factory SupabaseConfig._init(DotEnv env) {
    _instance ??= SupabaseConfig._(env);
    return _instance!;
  }

  SupabaseConfig._(DotEnv env) {
    url = env.getOrThrow('SUPABASE_URL');
    jwtSecret = env.getOrThrow('SUPABASE_JWT_SECRET');
    serviceRoleKey = env.getOrThrow('SUPABASE_SERVICE_ROLE_KEY');
  }

  late final String url;
  late final String jwtSecret;
  late final String serviceRoleKey;
}
