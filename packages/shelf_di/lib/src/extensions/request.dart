import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_di/shelf_di.dart';

extension ShelfDiExtension on Request {
  FutureOr<T> get<T extends Object>({String? key}) async {
    return Container.fromContext(context).get<T>(this, key: key);
  }

  void useValue<T extends Object>(T value, {String? key}) {
    Container.fromContext(context).useValue<T>(value, key: key);
  }

  void useFactory<T extends Object>(FactoryFunc<T> factory, {String? key}) {
    Container.fromContext(context).useFactory<T>(factory, key: key);
  }
}
