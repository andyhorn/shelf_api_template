import 'dart:convert';

import 'package:shelf_di/shelf_di.dart';
import 'package:shelf/shelf.dart';

class MyClass {
  const MyClass({required this.value});

  final String value;

  Map<String, dynamic> toJson() => {
        'value': value,
      };
}

void main() async {
  var pipeline = const Pipeline();

  // inject the container
  pipeline = pipeline.addMiddleware(shelfContainer());

  // set up your values using useValue
  // this will set "hello world" as the value for type String
  pipeline = pipeline.addMiddleware(useValue('hello world'));

  // you can also set values with useFactory
  pipeline = pipeline.addMiddleware(useFactory((request) async {
    // This will set MyClass(value: 'value') as the value for type MyClass
    final value = await request.get<String>();
    return MyClass(value: value);
  }));

  final app = pipeline.addHandler((request) async {
    final value = await request.get<String>();
    final myClass = await request.get<MyClass>();

    return Response.ok(jsonEncode({
      'value': value,
      'myClass': myClass,
    }));
  });

  final response = await app(
    Request('GET', Uri.parse('http://localhost:8000/')),
  );

  print(await response.readAsString());
}
