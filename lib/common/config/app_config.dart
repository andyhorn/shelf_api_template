import 'package:dotenv/dotenv.dart';

final class AppConfig {
  static final instance = AppConfig._();

  AppConfig._() {
    final env = DotEnv(includePlatformEnvironment: true)..load();

    dbName = env['DB_NAME']!;
    dbHost = env['DB_HOST']!;
    dbPort = int.parse(env['DB_PORT']!);
    dbUser = env['DB_USER']!;
    dbPassword = env['DB_PASSWORD']!;
  }

  late final String dbName;
  late final String dbHost;
  late final int dbPort;
  late final String dbUser;
  late final String dbPassword;

  SupabaseConfig get supabase => SupabaseConfig.instance;
}

final class SupabaseConfig {
  static final instance = SupabaseConfig._();

  SupabaseConfig._() {
    final env = DotEnv(includePlatformEnvironment: true)..load();

    url = env['SUPABASE_URL']!;
    jwtSecret = env['SUPABASE_JWT_SECRET']!;
    serviceRoleKey = env['SUPABASE_SERVICE_ROLE_KEY']!;
  }

  late final String url;
  late final String jwtSecret;
  late final String serviceRoleKey;
}
