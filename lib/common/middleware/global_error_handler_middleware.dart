import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_api/common/errors/app_error.dart';

final globalErrorHandlerMiddleware = createMiddleware(
  errorHandler: (error, stackTrace) {
    if (error is AppError) {
      return error.toResponse();
    }

    final data = {
      'error': 'unknown-error',
      'message': '$error',
    };

    final json = jsonEncode(data);

    return Response.internalServerError(body: json);
  },
);
