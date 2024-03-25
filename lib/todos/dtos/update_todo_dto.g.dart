// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_todo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTodoDto _$UpdateTodoDtoFromJson(Map<String, dynamic> json) =>
    UpdateTodoDto(
      title: json['title'] as String?,
      completed: json['completed'] as bool?,
    );

Map<String, dynamic> _$UpdateTodoDtoToJson(UpdateTodoDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'completed': instance.completed,
    };
