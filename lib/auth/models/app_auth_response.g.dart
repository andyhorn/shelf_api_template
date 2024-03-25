// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppAuthResponse _$AppAuthResponseFromJson(Map<String, dynamic> json) =>
    AppAuthResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$AppAuthResponseToJson(AppAuthResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
