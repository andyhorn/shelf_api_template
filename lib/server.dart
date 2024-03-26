import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_api/auth/services/auth_client.dart';
import 'package:shelf_api/common/middleware/global_error_handler_middleware.dart';
import 'package:shelf_api/common/config/app_config.dart';
import 'package:shelf_api/common/database/database.dart';
import 'package:shelf_api/auth/routes/auth_routes.dart';
import 'package:shelf_api/todos/routes/todos_routes.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_di/shelf_di.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:supabase/supabase.dart';

class Server {
  const Server();

  Handler get _handler {
    final router = Router();

    router.mount('/auth', AuthRoutes().handler);
    router.mount('/todos', TodosRoutes().handler);

    final app = _injectGlobalMiddleware(router);
    return app;
  }

  Future<void> run({
    required int? port,
    required Object? internetAddress,
  }) async {
    final server = await io.serve(
      _handler,
      internetAddress ?? InternetAddress.anyIPv4,
      port ?? 3000,
    );

    print('🚀 Listening to http://${server.address.host}:${server.port}');
  }

  Handler _injectGlobalMiddleware(Router router) {
    return const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(corsHeaders())
        .addMiddleware(globalErrorHandlerMiddleware)
        .addMiddleware(shelfContainer())
        .addMiddleware(useFactory((request) async {
          final db = await Database.open();
          return db;
        }))
        .addMiddleware(useValue(SupabaseClient(
          AppConfig.instance.supabase.url,
          AppConfig.instance.supabase.serviceRoleKey,
        )))
        .addMiddleware(useFactory((request) async {
          final client = await request.get<SupabaseClient>();
          final authClient = AuthClient(client);
          return authClient;
        }))
        .addHandler(router.call)
        .call;
  }
}
