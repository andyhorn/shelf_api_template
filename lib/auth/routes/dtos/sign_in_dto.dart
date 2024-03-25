import 'package:json_annotation/json_annotation.dart';

part 'sign_in_dto.g.dart';

@JsonSerializable()
class SignInDto {
  const SignInDto({
    required this.email,
    required this.password,
  });

  factory SignInDto.fromJson(Map<String, dynamic> json) =>
      _$SignInDtoFromJson(json);

  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$SignInDtoToJson(this);

  @override
  String toString() {
    return 'SignInDto{email: $email, password: $password}';
  }
}
