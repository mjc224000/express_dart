
import 'dart:io';
import 'package:path/path.dart' as p;
 class MimeTypes {
  /// Mime type for HTML
  static const String html = "text/html";

  /// Mime type for XHTML
  static const String xhtml = "application/xhtml+xml";

  /// Mime type for Javascript
  static const String javascript = "application/javascript";

  /// Mime type for CSS
  static const String css = "text/css";

  /// Mime type for Dart
  static const String dart = "application/dart";

  /// Mime type for PNG
  static const String png = "image/png";

  /// Mime type for JPEG
  static const String jpeg = "image/jpeg";

  /// Mime type for GIF
  static const String gif = "image/gif";

  static const String webp = "image/webp";
  static const String bmp = "image/bmp";

  /// Mime type for JSON
  static const String json = "application/json";

  /// Mime type form-urlencoded
  static const String urlEncodedForm = 'application/x-www-form-urlencoded';

  /// Mime type for multipart form data
  static const String multipartForm = 'multipart/form-data';

  /// mime type for binary
  static const String binary = 'application/octet-stream';

  /// Mime type for SVG
  static const String svg = "image/svg+xml";

  static const wav = "video/wav";

  static const mp3 = "audio/mpeg3";

  static const gp3 = "video/3gpp";

  static const avi = "video/avi";

  static const mov = "video/quicktime";

  static const mp4 = "video/mp4";

  static const flv = "video/x-flv";

  static const webm = "video/webm";

  static const pdf = "application/pdf";

  static const rar = "application/x-rar-compressed";

  static const zip = "application/zip";

  static const txt = "text/plain";

  static const tar = "application/x-tar";

  /// Map of file extension to mime type
  static const fromFileExtension = const <String, String>{
    "html": html,
    "xhtml": xhtml,
    "js": javascript,
    "css": css,
    "dart": dart,
    "png": png,
    "jpg": jpeg,
    "jpeg": jpeg,
    "gif": gif,
    "bmp": bmp,
    "webp": webp,
    "svg": svg,
    "wav": wav,
    "mp3": mp3,
    "3gp": gp3,
    "avi": avi,
    "mov": mov,
    "mp4": mp4,
    "flv": flv,
    "webm": webm,
    "rar": rar,
    "txt": txt,
    "zip": zip,
    "tar": tar,
  };

  /// Returns mime type of [file] based on its extension
  static String? ofFile(File file) {
    String fileExtension = p.extension(file.path,5);

    if (fileExtension.startsWith('.'))
      fileExtension = fileExtension.substring(1);

    if (fileExtension.length == 0) return null;

    if (fromFileExtension.containsKey(fileExtension)) {
      return fromFileExtension[fileExtension];
    }

    return null;
  }
}