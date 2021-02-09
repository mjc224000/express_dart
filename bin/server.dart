import 'dart:collection';
import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:jaguar/jaguar.dart';
import 'package:path/path.dart';
import 'express.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

void main(List<String> args) async {
   var app =express();
app.get('/',Application.static('view'));
  app.listen(4044);




}
