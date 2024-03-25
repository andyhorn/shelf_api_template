import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.completedAt,
    required this.createdAt,
    required this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  final String id;

  final String title;

  @JsonKey(name: 'created_at', fromJson: _deserializeDateTime)
  final DateTime createdAt;

  @JsonKey(name: 'completed_at', fromJson: _deserializeDateTimeNullable)
  final DateTime? completedAt;

  @JsonKey(name: 'user_id')
  final String userId;

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  @override
  String toString() {
    return 'Todo{title: $title, completedAt: $completedAt, createdAt: $createdAt, userId: $userId}';
  }

  static DateTime? _deserializeDateTimeNullable(dynamic val) =>
      val == null ? null : val as DateTime;

  static DateTime _deserializeDateTime(dynamic val) => val as DateTime;
}
