import 'package:shelf/shelf.dart';

Middleware middleware() =>
        (innerHandler) {
      return (request) {
        return Future.sync(() =>
            innerHandler(request)).then(
                (response) {
              return response;
            }, onError: () {

        });
      };
    };