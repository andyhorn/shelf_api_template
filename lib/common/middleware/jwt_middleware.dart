import 'package:shelf/shelf.dart';
import 'package:shelf_api/auth/services/auth_client.dart';
import 'package:shelf_api/common/errors/app_error.dart';
import 'package:shelf_di/shelf_di.dart';

final jwtMiddleware = createMiddleware(
  requestHandler: (request) async {
    final auth = request.headers['Authorization'];

    if (auth == null || !auth.startsWith('Bearer ')) {
      throw InvalidTokenError();
    }

    final token = auth.split('Bearer ').last;
    final authClient = await request.get<AuthClient>();
    final user = await authClient.validate(token);

    request.useValue(user);

    return null;
  },
);
