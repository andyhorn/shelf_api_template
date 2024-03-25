import 'dart:convert';

import 'package:shelf/shelf.dart';

sealed class AppError extends Error {
  AppError(this.code, this.message);
  final String code;
  final String message;

  Response toResponse();

  Map<String, dynamic> toJson() => {
        'error': code,
        'message': message,
      };
}

class UnknownError extends AppError {
  UnknownError(Object error)
      : super(
          'unknown-error',
          '$error',
        );

  @override
  Response toResponse() {
    return Response.internalServerError(body: jsonEncode(toJson()));
  }
}

class InvalidTokenError extends AppError {
  InvalidTokenError()
      : super(
          'invalid-token',
          'The JWT is invalid.',
        );

  @override
  Response toResponse() {
    return Response.unauthorized(jsonEncode(toJson()));
  }
}

class InvalidRefreshTokenError extends AppError {
  InvalidRefreshTokenError()
      : super(
          'invalid-refresh-token',
          'The refresh token is invalid.',
        );

  @override
  Response toResponse() {
    return Response.unauthorized(jsonEncode(toJson()));
  }
}

class InvalidLoginError extends AppError {
  InvalidLoginError()
      : super(
          'invalid-login',
          'The email or password are incorrect.',
        );

  @override
  Response toResponse() {
    return Response.unauthorized(jsonEncode(toJson()));
  }
}

class UserNotFoundError extends AppError {
  UserNotFoundError()
      : super(
          'user-not-found',
          'The user was not found.',
        );

  @override
  Response toResponse() {
    return Response.notFound(jsonEncode(toJson()));
  }
}

class EmailInUseError extends AppError {
  EmailInUseError()
      : super(
          'email-in-use',
          'The email is already in use.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

class BadMultipleError extends AppError {
  BadMultipleError()
      : super(
          'bad-multiple',
          'The email and phone number are invalid.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

class EmailNotConfirmedError extends AppError {
  EmailNotConfirmedError()
      : super(
          'email-not-confirmed',
          'The email is not confirmed.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

class BadPhoneNumberError extends AppError {
  BadPhoneNumberError()
      : super(
          'bad-phone-number',
          'The phone number is invalid.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

class BadEmailAddressError extends AppError {
  BadEmailAddressError()
      : super(
          'bad-email-address',
          'The email address is invalid.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

class TooManyRequestsError extends AppError {
  TooManyRequestsError()
      : super(
          'too-many-requests',
          'Too many requests.',
        );

  @override
  Response toResponse() {
    return Response.badRequest(body: jsonEncode(toJson()));
  }
}

class RegistrationError extends AppError {
  RegistrationError()
      : super(
          'registration-error',
          'Failed to register the user',
        );

  @override
  Response toResponse() {
    return Response.internalServerError(body: jsonEncode(toJson()));
  }
}

class LoginError extends AppError {
  LoginError()
      : super(
          'login-error',
          'Failed to sign in',
        );

  @override
  Response toResponse() {
    return Response.internalServerError(body: jsonEncode(toJson()));
  }
}

class InvalidGrantTypeError extends AppError {
  InvalidGrantTypeError()
      : super(
          'invalid-grant-type',
          'Invalid grant type',
        );

  @override
  Response toResponse() {
    return Response.forbidden(jsonEncode(toJson()));
  }
}
