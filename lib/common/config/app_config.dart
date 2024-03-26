import 'package:dotenv/dotenv.dart';

class _MissingConfigValueError extends Error {
  _MissingConfigValueError(this.key);

  final String key;

  @override
  String toString() => 'Missing config value for key: $key';
}

mixin _ConfigExtractor {
  String getString(DotEnv env, String key) {
    return env.getOrElse(key, () => throw _MissingConfigValueError(key));
  }

  int getInt(DotEnv env, String key) {
    return int.parse(getString(env, key));
  }
}

final class AppConfig with _ConfigExtractor {
  static AppConfig? _instance;

  factory AppConfig() {
    _instance ??= AppConfig.init();
    return _instance!;
  }

  AppConfig.init() {
    final env = DotEnv(includePlatformEnvironment: true)..load();

    dbName = getString(env, 'DB_NAME');
    dbHost = getString(env, 'DB_HOST');
    dbPort = getInt(env, 'DB_PORT');
    dbUser = getString(env, 'DB_USER');
    dbPassword = getString(env, 'DB_PASSWORD');

    supabase = SupabaseConfig._init(env);
  }

  late final String dbName;
  late final String dbHost;
  late final int dbPort;
  late final String dbUser;
  late final String dbPassword;

  late final SupabaseConfig supabase;
}

final class SupabaseConfig with _ConfigExtractor {
  static SupabaseConfig? _instance;

  factory SupabaseConfig._init(DotEnv env) {
    _instance ??= SupabaseConfig._(env);
    return _instance!;
  }

  SupabaseConfig._(DotEnv env) {
    url = getString(env, 'SUPABASE_URL');
    jwtSecret = getString(env, 'SUPABASE_JWT_SECRET');
    serviceRoleKey = getString(env, 'SUPABASE_SERVICE_ROLE_KEY');
  }

  late final String url;
  late final String jwtSecret;
  late final String serviceRoleKey;
}
