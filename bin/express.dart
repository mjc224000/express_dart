import 'dart:async';
import 'dart:io';

import 'dart:typed_data';

import 'MimeType.dart';

class Application {
  var _server;
  final Map<String, List<Function>> _stack = {};
  final Map<String, Map<String, List>> _layers = {};

  void listen(int port) async {
    _server = await HttpServer.bind('0.0.0.0', port);
    await for (HttpRequest req in _server) {
      var uri = req.uri;
      var method = req.method;
      //_layers['/']?['get']?.first(req,req.response,()async{});
      // compose(_layers['/']?['get']!)(req,req.response,()async{});
      static("view")(req, req.response, () async {});
    }
  }

  void get(String path, fn) {
    if (_layers[path] == null) {
      _layers[path] = {};
      if (_layers[path]?['get'] == null) {
        _layers[path]?['get'] = [];
      }
      _layers[path]?['get']?.add(fn);
    }
  }

  static Future<Null> Function(HttpRequest req, HttpResponse res, Function next)
      static(String path) {
    var _startTime = DateTime.now();
    return (HttpRequest req, HttpResponse res, Function next) async {
      _startTime = DateTime.now();
      var uri = req.uri.toString() == '/'
          ? '/index.html'
          : Uri.decodeComponent(req.uri.toString());
      var filePath = path + uri;
      var file = File(filePath);
      if (await file.exists()) {
        req.response.headers
            .add('content-type', MimeTypes.ofFile(file).toString());
        req.response.headers
            .add('Cache-Control', 'public, immutable, max-age=86400');
        req.response.headers.add('Accept-Ranges', 'bytes');
        req.response.headers.contentLength = await file.length();
        req.response.headers.add('Last-Modified', _startTime);
        await file.openRead().pipe(res);
        await req.response.close();
        next();
      } else {
        res
          ..statusCode = HttpStatus.notFound
          ..close();
      }
    };
  }

  void use(String path, Future<Function> fn, String method) {
    if (_layers[path] == null) {
      _layers[path] = {};
    }
    if (_layers[path]?[method] == null) {
      _layers[path]?[method] = [];
    }
    //_layers[path]?[method]?.add(fn);
  }

  void _static(String path, String file) {}

  void connect() {
    _stack.keys.forEach((element) {});
  }

  dynamic compose(List fns) {
    return fns.reduce((value, element) async {
      return (HttpRequest req, HttpResponse res, next) {
        value(req, res, () => element(req, res, next));
      };
    });
  }
}

Application express() {
  return Application();
}
