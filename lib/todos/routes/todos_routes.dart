import 'dart:async';
import 'dart:convert';

import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_api/common/middleware/jwt_middleware.dart';
import 'package:shelf_api/todos/dtos/create_todo_dto.dart';
import 'package:shelf_api/todos/services/todos_repository.dart';
import 'package:shelf_api/todos/dtos/update_todo_dto.dart';
import 'package:shelf_di/shelf_di.dart';
import 'package:shelf_router/shelf_router.dart';

class TodosRoutes {
  Handler get handler {
    final router = Router();

    router.get('/', _get);
    router.post('/', _create);
    router.put('/<id>', _update);

    return const Pipeline()
        .addMiddleware(jwtMiddleware)
        .addMiddleware(useFactory((request) async {
          final db = await request.get<Connection>();
          return TodosRepository(db);
        }))
        .addHandler(router.call)
        .call;
  }

  FutureOr<Response> _get(Request request) async {
    final UserId(:id) = await request.get<UserId>();
    final todosRepository = await request.get<TodosRepository>();

    final todos = await todosRepository.findByUserId(id);
    return Response.ok(jsonEncode(todos));
  }

  FutureOr<Response> _create(Request request) async {
    final UserId(:id) = await request.get<UserId>();
    final body = await request.readAsString();
    final dto = CreateTodoDto.fromJson(jsonDecode(body));
    final todosRepository = await request.get<TodosRepository>();
    final todo = await todosRepository.create((title: dto.title, userId: id));

    return Response.ok(jsonEncode(todo));
  }

  FutureOr<Response> _update(Request request, String id) async {
    final UserId(id: userId) = await request.get<UserId>();
    final body = await request.readAsString();
    final dto = UpdateTodoDto.fromJson(jsonDecode(body));
    final todosRepository = await request.get<TodosRepository>();
    final todo = await todosRepository.update((
      completed: dto.completed,
      title: dto.title,
      todoId: id,
      userId: userId,
    ));

    if (todo == null) {
      return Response.notFound(
        jsonEncode({
          'error': 'not-found',
          'message': 'Todo not found',
        }),
      );
    }

    return Response.ok(jsonEncode(todo));
  }
}
