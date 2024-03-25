import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_di/shelf_di.dart';
import 'package:test/test.dart';

const int testValue = 42;
String testFactoryValueBuilder(int value) => 'value is $value';

void main() {
  Future<String> getResponse(FutureOr<Response> Function(Request) app) async {
    final response = await app(Request(
      'GET',
      Uri.parse('http://localhost:8000/'),
    ));

    return response.readAsString();
  }

  group('$Container', () {
    group('static middleware', () {
      final pipeline = const Pipeline()
          .addMiddleware(shelfContainer())
          .addMiddleware(useValue(testValue))
          .addMiddleware(useFactory((request) async {
        final value = await request.get<int>();
        return testFactoryValueBuilder(value);
      }));

      group('useValueMiddleware', () {
        test('injects useValue value', () async {
          final app = pipeline.addHandler((request) async {
            final value = await request.get<int>();
            return Response.ok('$value');
          });

          final response = await getResponse(app);

          expect(response, testValue.toString());
        });
      });

      group('useFactoryMiddleware', () {
        test('injects useFactory value', () async {
          final app = pipeline.addHandler((request) async {
            final value = await request.get<String>();
            return Response.ok(value);
          });

          final response = await getResponse(app);

          expect(response, testFactoryValueBuilder(testValue));
        });
      });
    });

    group('extensions', () {
      final pipeline = const Pipeline()
          .addMiddleware(shelfContainer())
          .addMiddleware(useValue(testValue))
          .addMiddleware(useFactory((request) async {
        final value = await request.get<int>();
        return testFactoryValueBuilder(value);
      }));

      group('useValue', () {
        test('injects useValue value', () async {
          final app = pipeline.addHandler((request) async {
            final value = await request.get<int>();
            return Response.ok('$value');
          });

          final response = await getResponse(app);

          expect(response, testValue.toString());
        });
      });

      group('useFactory', () {
        test('injects useFactory value', () async {
          final app = pipeline.addHandler((request) async {
            final value = await request.get<String>();
            return Response.ok(value);
          });

          final response = await getResponse(app);

          expect(response, testFactoryValueBuilder(testValue));
        });
      });
    });
  });
}
