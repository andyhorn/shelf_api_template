import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_di/src/extensions/_request.dart';

typedef FactoryFunc<T extends Object> = FutureOr<T> Function(Request request);

Middleware shelfContainer() {
  return (Handler handler) {
    return (Request request) {
      return handler(
        request.change(
          context: {
            Container.key: Container(),
          },
        ),
      );
    };
  };
}

Middleware useFactory<T extends Object>(FactoryFunc<T> factory, {String? key}) {
  return (Handler handler) {
    return (Request request) async {
      request = request.withContainer();
      Container.fromContext(request.context).useFactory<T>(factory, key: key);
      return handler(request);
    };
  };
}

Middleware useValue<T extends Object>(T value, {String? key}) {
  return (Handler handler) {
    return (Request request) {
      request = request.withContainer();
      Container.fromContext(request.context).useValue<T>(value, key: key);
      return handler(request);
    };
  };
}

final class Container {
  Container();

  static const key = 'shelf:container';

  static Container fromContext(Map<String, Object> context) {
    return context[key] as Container;
  }

  final Map<String, Object> _values = {};

  void useValue<T extends Object>(T value, {String? key}) {
    _values[key ?? T.toString()] = value;
  }

  void useFactory<T extends Object>(
    FactoryFunc factory, {
    String? key,
  }) {
    _values[key ?? T.toString()] = factory;
  }

  FutureOr<T> get<T extends Object>(Request request, {String? key}) async {
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
