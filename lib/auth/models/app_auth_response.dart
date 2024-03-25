import 'package:json_annotation/json_annotation.dart';

part 'app_auth_response.g.dart';

@JsonSerializable()
class AppAuthResponse {
  const AppAuthResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AppAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AppAuthResponseFromJson(json);

  final String accessToken;
  final String refreshToken;

  Map<String, dynamic> toJson() => _$AppAuthResponseToJson(this);

  @override
  String toString() {
    return 'AppAuthResponse{accessToken: $accessToken, refreshToken: $refreshToken}';
  }
}
