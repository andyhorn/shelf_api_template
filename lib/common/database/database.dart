import 'package:postgres/postgres.dart';
import 'package:shelf_api/common/config/app_config.dart';

final class Database {
  const Database._();

  static Future<Connection> open() {
    return Connection.open(
      _getEndpoint(),
      settings: _getSettings(),
    );
  }

  static Endpoint _getEndpoint() {
    return Endpoint(
      database: AppConfig.dbName,
      host: AppConfig.dbHost,
      password: AppConfig.dbPassword,
      port: AppConfig.dbPort,
      username: AppConfig.dbUser,
    );
  }

  static ConnectionSettings _getSettings() {
    return ConnectionSettings(
      applicationName: 'shelf_api',
      timeZone: 'UTC',
      sslMode: SslMode.disable,
    );
  }
}
