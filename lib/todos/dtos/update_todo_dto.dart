import 'package:json_annotation/json_annotation.dart';

part 'update_todo_dto.g.dart';

@JsonSerializable()
class UpdateTodoDto {
  const UpdateTodoDto({
    required this.title,
    required this.completed,
  });

  factory UpdateTodoDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTodoDtoFromJson(json);

  final String? title;
  final bool? completed;

  Map<String, dynamic> toJson() => _$UpdateTodoDtoToJson(this);

  @override
  String toString() => 'UpdateTodoDto(title: $title, completed: $completed)';
}
