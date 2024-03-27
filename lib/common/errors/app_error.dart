import 'dart:convert';

import 'package:shelf/shelf.dart';

abstract base class AppError extends Error {
  AppError({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  Response toResponse();

  Map<String, dynamic> toJson() => {
        'error': code,
        'message': message,
      };
}

final class UnknownError extends AppError {
  UnknownError(Object error)
      : super(
          code: 'unknown-error',
          message: '$error',
        );

  @override
  Response toResponse() {
    return Response.internalServerError(body: jsonEncode(toJson()));
  }
}

final class InvalidTokenError extends AppError {
  InvalidTokenError()
      : super(
          code: 'invalid-token',
          message: 'The JWT is invalid.',
        );

  @override
  Response toResponse() {
    return Response.unauthorized(jsonEncode(toJson()));
  }
}

final class InvalidRefreshTokenError extends AppError {
  InvalidRefreshTokenError()
      : super(
          code: 'invalid-refresh-token',
          message: 'The refresh token is invalid.',
        );

  @override
  Response toResponse() {
    return Response.unauthorized(jsonEncode(toJson()));
  }
}

final class InvalidLoginError extends AppError {
  InvalidLoginError()
      : super(
          code: 'invalid-login',
          message: 'The email or password are incorrect.',
        );

  @override
  Response toResponse() {
    return Response.unauthorized(jsonEncode(toJson()));
  }
}

final class UserNotFoundError extends AppError {
  UserNotFoundError()
      : super(
          code: 'user-not-found',
          message: 'The user was not found.',
        );

  @override
  Response toResponse() {
    return Response.notFound(jsonEncode(toJson()));
  }
}

final class EmailInUseError extends AppError {
  EmailInUseError()
      : super(
          code: 'email-in-use',
          message: 'The email is already in use.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

final class BadMultipleError extends AppError {
  BadMultipleError()
      : super(
          code: 'bad-multiple',
          message: 'The email and phone number are invalid.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

final class EmailNotConfirmedError extends AppError {
  EmailNotConfirmedError()
      : super(
          code: 'email-not-confirmed',
          message: 'The email is not confirmed.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

final class BadPhoneNumberError extends AppError {
  BadPhoneNumberError()
      : super(
          code: 'bad-phone-number',
          message: 'The phone number is invalid.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

final class BadEmailAddressError extends AppError {
  BadEmailAddressError()
      : super(
          code: 'bad-email-address',
          message: 'The email address is invalid.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

final class TooManyRequestsError extends AppError {
  TooManyRequestsError()
      : super(
          code: 'too-many-requests',
          message: 'Too many requests.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

final class RegistrationError extends AppError {
  RegistrationError()
      : super(
          code: 'registration-error',
          message: 'Failed to register the user',
        );

  @override
  Response toResponse() {
    return Response.internalServerError(body: jsonEncode(toJson()));
  }
}

final class LoginError extends AppError {
  LoginError()
      : super(
          code: 'login-error',
          message: 'Failed to sign in',
        );

  @override
  Response toResponse() {
    return Response.internalServerError(body: jsonEncode(toJson()));
  }
}

final class InvalidGrantTypeError extends AppError {
  InvalidGrantTypeError()
      : super(
          code: 'invalid-grant-type',
          message: 'Invalid grant type',
        );

  @override
  Response toResponse() {
    return Response.forbidden(jsonEncode(toJson()));
  }
}
