import 'package:shelf/shelf.dart';

extension HandlerExtensions on Handler {
  Handler withMiddleware(List<Middleware> middleware) {
    var pipeline = const Pipeline();

    for (final m in middleware) {
      pipeline = pipeline.addMiddleware(m);
    }

    return pipeline.addHandler(this);
  }
}
