// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Type localhost:4048 into your browser.
// This server returns the contents of index.html for all requests.

import 'dart:io';
import 'dart:async';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart';

Future main() async {
  var pathToBuild = join(dirname(Platform.script.toFilePath()));

  var staticFiles = new VirtualDirectory(pathToBuild);
  staticFiles.allowDirectoryListing = true;
  staticFiles.directoryHandler = (dir, request) {
    var indexUri = new Uri.file(dir.path).resolve('index.html');
    staticFiles.serveFile(new File(indexUri.toFilePath()), request);
  };

  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4048);
  print('Listening on port 4048');
  await server.forEach(staticFiles.serveRequest);
}
