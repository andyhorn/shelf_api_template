import 'dart:io';

import 'package:shelf_api/server.dart';

Future<void> main() async {
  await const Server().run(
    port: int.tryParse(Platform.environment['PORT'] ?? ''),
    internetAddress: Platform.environment['IP_ADDRESS'],
  );
}
