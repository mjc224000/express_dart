import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'MimeType.dart';
import 'Multiparty.dart';
import 'express.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

void main(List<String> args) async {
/*   var app =express();
app.get('/',Application.static('view'));
  app.listen(4044);*/

  var _startTime = DateTime.now();
  print(_startTime.toString().replaceAll(RegExp(r'\D'), ''));
  print( Random().nextInt(10));
  var _server = await HttpServer.bind('0.0.0.0', 4044);
  await for (HttpRequest req in _server) {
    if (req.method.toUpperCase() == 'POST') {
      var res = req.response;
      var contentType = req.headers.contentType;
      print(req.headers.contentLength.toString() + ' content-length');
      await req
          .pipe(Multiparty(contentType.toString(), req.headers.contentLength));

      res.statusCode = HttpStatus.noContent;
      await res.close();
    } else {
      _startTime = DateTime.now();
      var uri = req.uri.toString() == '/'
          ? '/index.html'
          : Uri.decodeComponent(req.uri.toString());
      var filePath = 'view' + uri;
      var file = File(filePath);
      if (await file.exists()) {
        req.response.headers
            .add('content-type', MimeTypes.ofFile(file).toString());
     /*   req.response.headers
            .add('Cache-Control', 'public, immutable, max-age=86400');*/
        req.response.headers.add('Accept-Ranges', 'bytes');
        req.response.headers.contentLength = await file.length();
        //req.response.headers.add('Last-Modified', _startTime);
        await file.openRead().pipe(req.response);
        await req.response.close();
        // next();
      } else {
        req.response
          ..statusCode = HttpStatus.notFound
          ..close();
      }
    }
  }
  ;
}
