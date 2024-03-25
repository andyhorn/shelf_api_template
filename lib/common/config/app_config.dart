import 'package:dotenv/dotenv.dart';

final class AppConfig {
  static AppConfig? _instance;
  static AppConfig get instance {
    _instance ??= AppConfig._(
      DotEnv(
        includePlatformEnvironment: true,
      )..load(),
    );
    return _instance!;
  }

  AppConfig._(this._env);

  final DotEnv _env;

  late final SupabaseConfig supabase = SupabaseConfig._(env: _env);
}

final class SupabaseConfig {
  const SupabaseConfig._({
    required this.env,
  });

  final DotEnv env;

  String get url => env['SUPABASE_URL']!;
  String get jwtSecret => env['SUPABASE_JWT_SECRET']!;
  String get serviceRoleKey => env['SUPABASE_SERVICE_ROLE_KEY']!;
  String get dbName => env['SUPABASE_DB_NAME']!;
  String get dbHost => env['SUPABASE_DB_HOST']!;
  int get dbPort => int.parse(env['SUPABASE_DB_PORT']!);
  String get dbUser => env['SUPABASE_DB_USER']!;
  String get dbPassword => env['SUPABASE_DB_PASSWORD']!;
}
