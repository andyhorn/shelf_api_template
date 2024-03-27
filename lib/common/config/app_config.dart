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

sealed class AppConfig {
  static final _env = DotEnv(includePlatformEnvironment: true)..load();

  static final String dbName = _env.getOrThrow(
    'DB_NAME',
  );

  static final String dbHost = _env.getOrThrow(
    'DB_HOST',
  );

  static final int dbPort = int.parse(
    _env.getOrThrow(
      'DB_PORT',
    ),
  );

  static final String dbUser = _env.getOrThrow(
    'DB_USER',
  );

  static final String dbPassword = _env.getOrThrow(
    'DB_PASSWORD',
  );

  static final String supabaseUrl = _env.getOrThrow(
    'SUPABASE_URL',
  );

  static final String supabaseJwtSecret = _env.getOrThrow(
    'SUPABASE_JWT_SECRET',
  );

  static final String supabaseServiceRoleKey = _env.getOrThrow(
    'SUPABASE_SERVICE_ROLE_KEY',
  );
}
