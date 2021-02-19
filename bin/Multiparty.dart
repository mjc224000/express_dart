import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

// don't try to read my code unless you are familiar with multipart/form-data
enum Status {
  boundary, // encountering a boundary like data
  file_spec, //parsing Content-Disposition and Content-Type
  data, // binary file data
  begin, // first line
  done
}

class MultipartyFile {
  late String filename;
  late File originFile;
  late String path;
  late String fieldName;
}

class Multiparty implements StreamConsumer<Uint8List> {
  String contentType;
  String Content_Type = 'Content-Type:';
  late String boundary;
  late String _start_boundary;
  late String _middle_boundary;
  late String _end_boundary;
  late File curFile;
  late RandomAccessFile access;
  Status _status = Status.begin;
  late num count = 0;
  var fileList = <MultipartyFile>[];
  var buffer = <int>[];
  var boundaryIndex = 0;
  var boundary_reg = RegExp('(?:boundary=)([\-0-9a-zA-Z]+)');
  var file_spec_filename_reg = RegExp('filename\="([^"]*)"', multiLine: true);
  var file_spec_field_name_reg = RegExp('name\="([^"]*)"', multiLine: true);
  var contentLength;

  // 计算file spec 归位键 \n 发现两个算完结;
  var _file_spec_count_cr = 0;

  Multiparty(this.contentType, this.contentLength) {
    var matches = boundary_reg.firstMatch(contentType);
    boundary = matches?.group(1)!;
    _start_boundary = '--' + boundary + '\r\n';
    _middle_boundary = '\r\n--' + boundary + '\r\n';
    _end_boundary = '\r\n--' + boundary + '--' + '\r\n';
  }

  void handleFileSpec(int c) {
    buffer.add(c);
    if (String.fromCharCode(c) == '\n') {
      _file_spec_count_cr += 1;
    }
    if (_file_spec_count_cr == 3) {
      var text = utf8.decode(buffer);
      file_spec_filename_reg.isMultiLine;
      var filenameMatches = file_spec_filename_reg.firstMatch(text);
      var filename = filenameMatches?.group(1);
      var f = MultipartyFile();
      var timeStamp = DateTime.now().toString().replaceAll(RegExp(r'\D'), '');
      if (filename != null) {
        f.filename = timeStamp + filename;
      } else {
        f.filename = timeStamp;
      }
      var fieldNameMatches = file_spec_field_name_reg.firstMatch(text);
      if (fieldNameMatches != null) {
        f.fieldName = fieldNameMatches.group(1)!;
      }
      var file = File('upload/' + f.filename);
      f.originFile = file;
      _status = Status.data;
      fileList.add(f);
      print(utf8.decode(buffer));
      buffer.clear();
    }
  }

  Future handleSaveData(int c) async {
/*    buffer.add(c);
    if (buffer.length > 12240) {
      await  fileList.last.originFile
          .writeAsBytes(buffer, mode: FileMode.append);
      buffer.clear();
    }*/

    //  print(String.fromCharCodes(buffer)+"buff'");
    /*  if (char == _middle_boundary[boundaryIndex]) {
      buffer.add(c);
      boundaryIndex++;
      return;
    }

    if (buffer.isNotEmpty) {
      buffer.add(c);
      var access = curFile.openWrite();
      buffer.forEach((element) {
        access.writeCharCode(element);
      });
      buffer.clear();
      boundaryIndex = 0;
      await access.close();
      return;
    }*/
  }

  Future parser(int c) async {
    switch (_status) {
      case Status.file_spec:
        {
          handleFileSpec(c);
          break;
        }
      case Status.begin:
        {
          var char = String.fromCharCode(c);
          if (char == _start_boundary[boundaryIndex]) {
            buffer.add(c);
            boundaryIndex++;
          } else {
            buffer.clear();
            boundaryIndex = 0;
          }
          if (boundaryIndex == _start_boundary.length) {
            //  print('解析到一个');
            _status = Status.file_spec;
            buffer.clear();
            boundaryIndex = 0;
          }
          break;
        }
      case Status.data:
        {
          await handleSaveData(c);
          break;
        }

      case Status.boundary:
        // TODO: Handle this case.
        break;
      case Status.done:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Future addStream(Stream<Uint8List> stream) async {
    var e = contentLength - _end_boundary.length;
    await stream.forEach((element) async {
      /* for (var i = 0; i < element.length; i++) {
        if (count < e) {
          if (count % 1024 == 0) {
            print(count / 1024);
          }
          await parser(element[i]);
          count++;
        }
      }*/
      print(element.length);
    });
    return Future(() {});
  }

  @override
  Future close() {
    // TODO: implement close

    return Future(() {});
  }
}
