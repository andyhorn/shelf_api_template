import 'package:shelf/shelf.dart';
import 'package:shelf_di/shelf_di.dart';

extension PrivateRequestExtensions on Request {
  Request withContainer() {
    if (!context.containsKey(Container.key)) {
      return change(
        context: {
          Container.key: Container(),
        },
      );
    }

    return this;
  }
}
