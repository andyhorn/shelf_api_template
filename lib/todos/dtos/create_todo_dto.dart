import 'package:json_annotation/json_annotation.dart';

part 'create_todo_dto.g.dart';

@JsonSerializable()
class CreateTodoDto {
  const CreateTodoDto({
    required this.title,
  });

  factory CreateTodoDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTodoDtoFromJson(json);

  final String title;

  Map<String, dynamic> toJson() => _$CreateTodoDtoToJson(this);

  @override
  String toString() {
    return 'CreateTodoDto{title: $title}';
  }
}
