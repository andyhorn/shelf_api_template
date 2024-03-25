import 'package:postgres/postgres.dart';
import 'package:shelf_api/todos/models/create_todo_args.dart';
import 'package:shelf_api/todos/models/todo.dart';
import 'package:shelf_api/todos/models/update_todo_args.dart';

class TodosRepository {
  const TodosRepository(this._connection);
  final Connection _connection;

  Future<List<Todo>> findByUserId(String userId) async {
    final result = await _connection.execute(
      Sql.named('SELECT * FROM todos WHERE user_id = @userId'),
      parameters: {'userId': userId},
    );

    return result.map((row) => Todo.fromJson(row.toColumnMap())).toList();
  }

  Future<Todo> create(CreateTodoArgs args) async {
    final result = await _connection.execute(
      Sql.named(
        'INSERT INTO todos (user_id, title) VALUES (@userId, @title) RETURNING *',
      ),
      parameters: {
        'userId': args.userId,
        'title': args.title,
      },
    );

    return Todo.fromJson(result.first.toColumnMap());
  }

  Future<Todo?> update(UpdateTodoArgs args) async {
    final queryBuffer = StringBuffer('UPDATE todos SET');

    if (args.title != null) {
      queryBuffer.write(' title = @title');
    }

    if (args.title != null && args.completed != null) {
      queryBuffer.write(',');
    }

    if (args.completed == true) {
      queryBuffer.write(' completed_at = @completedAt');
    } else if (args.completed == false) {
      queryBuffer.write(' completed_at = NULL');
    }

    queryBuffer.write(' WHERE id = @id AND user_id = @userId RETURNING *');

    final query = queryBuffer.toString();

    final result = await _connection.execute(
      Sql.named(query),
      parameters: {
        'id': args.todoId,
        if (args.title != null) ...{
          'title': args.title,
        },
        if (args.completed != null) ...{
          'completedAt': DateTime.now(),
        },
        'userId': args.userId,
      },
    );

    if (result.isEmpty) {
      return null;
    }

    return Todo.fromJson(result.first.toColumnMap());
  }
}
