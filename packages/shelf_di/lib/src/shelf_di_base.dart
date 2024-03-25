import 'dart:async';

import 'package:shelf/shelf.dart';

typedef FactoryFunc<T extends Object> = FutureOr<T> Function(Request request);

const _containerKey = 'shelf.container';

Middleware shelfContainer() {
  return (Handler handler) {
    return (Request request) {
      return handler(
        request.change(
          context: {
            _containerKey: Container._(),
          },
        ),
      );
    };
  };
}

Middleware useFactory<T extends Object>(FactoryFunc<T> factory, {String? key}) {
  return (Handler handler) {
    return (Request request) async {
      request = _ensureContainerExists(request);
      final container = request.context[_containerKey] as Container;
      container._useFactory<T>(factory, key: key);
      return handler(request);
    };
  };
}

Middleware useValue<T extends Object>(T value, {String? key}) {
  return (Handler handler) {
    return (Request request) {
      request = _ensureContainerExists(request);
      final container = request.context[_containerKey] as Container;
      container._useValue<T>(value, key: key);
      return handler(request);
    };
  };
}

Request _ensureContainerExists(Request request) {
  if (!request.context.containsKey(_containerKey)) {
    return request.change(
      context: {
        _containerKey: Container._(),
      },
    );
  }

  return request;
}

final class Container {
  Container._();

  final Map<String, Object> _values = {};

  void _useValue<T extends Object>(T value, {String? key}) {
    _values[key ?? T.toString()] = value;
  }

  void _useFactory<T extends Object>(
    FactoryFunc factory, {
    String? key,
  }) {
    _values[key ?? T.toString()] = factory;
  }

  FutureOr<T> _get<T extends Object>(Request request, {String? key}) async {
    final value = _values[key ?? T.toString()];

    if (value is FactoryFunc) {
      final factory = value;
      final result = await factory(request);
      _values[key ?? T.toString()] = result;
      return result as T;
    }

    return value as T;
  }
}

extension ShelfDiExtension on Request {
  FutureOr<T> get<T extends Object>({String? key}) async {
    final container = context[_containerKey] as Container;
    return container._get<T>(this, key: key);
  }

  void useValue<T extends Object>(T value, {String? key}) {
    final container = context[_containerKey] as Container;
    container._useValue<T>(value, key: key);
  }

  void useFactory<T extends Object>(FactoryFunc<T> factory, {String? key}) {
    final container = context[_containerKey] as Container;
    container._useFactory<T>(factory, key: key);
  }
}
