import 'package:shelf_api/common/errors/app_error.dart';
import 'package:supabase/supabase.dart';

extension AuthExceptionExtensions on AuthException {
  static final _errorMap = <String, Map<String, AppError>>{
    '400': {
      'invalid login': InvalidLoginError(),
      'email not confirmed': EmailNotConfirmedError(),
      'user already registered': EmailInUseError(),
      'invalid refresh token': InvalidRefreshTokenError(),
    },
    '401': {
      'invalid token': InvalidTokenError(),
      'this endpoint requires a bearer token': InvalidTokenError(),
    },
    '422': {
      'email&&phone': BadMultipleError(),
      'email': BadEmailAddressError(),
      'phone': BadPhoneNumberError(),
    },
    '429': {
      '*': TooManyRequestsError(),
    },
  };

  AppError toAppError() {
    final normalizedMessage = message.toLowerCase();

    if (!_errorMap.containsKey(statusCode)) {
      return UnknownError(this);
    }

    final errorGroup = _errorMap[statusCode]!;
    final error = errorGroup.entries.toList().where((entry) {
      if (entry.key == '*') {
        return true;
      }

      if (entry.key.contains('&&')) {
        final keys = entry.key.split('&&');
        return keys.every((key) => normalizedMessage.contains(key));
      }

      return normalizedMessage.contains(entry.key);
    });

    if (error.isEmpty) {
      return UnknownError(this);
    }

    return error.first.value;
  }
}
