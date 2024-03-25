import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_api/auth/models/app_user.dart';
import 'package:shelf_api/auth/services/auth_client.dart';
import 'package:shelf_api/common/errors/app_error.dart';
import 'package:shelf_api/common/extensions/handler_ext.dart';
import 'package:shelf_api/common/middleware/jwt_middleware.dart';
import 'package:shelf_api/auth/routes/dtos/sign_in_dto.dart';
import 'package:shelf_api/auth/routes/dtos/sign_up_dto.dart';
import 'package:shelf_di/shelf_di.dart';
import 'package:shelf_router/shelf_router.dart';

final class AuthRoutes {
  Handler get handler {
    final router = Router();

    router.post('/sign-up', _signUp);
    router.post('/sign-in', _signIn);
    router.get('/whoami', _whoami.withMiddleware([jwtMiddleware]));
    router.post('/token', _refresh);
    router.delete('/', _delete.withMiddleware([jwtMiddleware]));

    return router.call;
  }

  FutureOr<Response> _signIn(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body);
    final dto = SignInDto.fromJson(json);
    final authClient = await request.get<AuthClient>();

    final response = await authClient.signIn((
      email: dto.email,
      password: dto.password,
    ));

    return Response.ok(jsonEncode(response));
  }

  FutureOr<Response> _signUp(Request request) async {
    final body = await request.readAsString();
    final dto = SignUpDto.fromJson(jsonDecode(body));
    final authClient = await request.get<AuthClient>();

    final user = await authClient.signUp((
      email: dto.email,
      password: dto.password,
    ));

    return Response.ok(jsonEncode(user));
  }

  FutureOr<Response> _whoami(Request request) async {
    final user = await request.get<AppUser>();

    return Response.ok(jsonEncode(user));
  }

  FutureOr<Response> _refresh(Request request) async {
    if (request.url.queryParameters['grant_type'] != 'refresh_token') {
      throw InvalidGrantTypeError();
    }

    final body = await request.readAsString();
    final token = jsonDecode(body)['token'];
    final authClient = await request.get<AuthClient>();
    final response = await authClient.refresh(token);
    return Response.ok(jsonEncode(response));
  }

  FutureOr<Response> _delete(Request request) async {
    final authClient = await request.get<AuthClient>();
    final user = await request.get<AppUser>();
    await authClient.deleteUser(user.id);

    return Response(
      HttpStatus.noContent,
    );
  }
}
