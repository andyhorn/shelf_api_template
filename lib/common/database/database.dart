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
    final config = AppConfig();

    return Endpoint(
      database: config.dbName,
      host: config.dbHost,
      password: config.dbPassword,
      port: config.dbPort,
      username: config.dbUser,
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
