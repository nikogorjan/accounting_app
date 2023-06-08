import 'dart:io';

import 'package:accounting_app/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

import '../data/data.dart';

class PdfApi {
  Storage storage = Storage();
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    late Directory dir;
    var file = File('');
    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final newWindow = html.window.open(url, '_blank');
    } else {
      dir = await getApplicationDocumentsDirectory();
      String path = '${dir.path}/$name';
      file = File('${dir.path}/$name');
      await file.writeAsBytes(await pdf.save());
      box.put('data', path);
    }

    return file;
  }

  void upload(String path, String name) {
    storage.UploadFileMobile(path, name, box.get('email'));
  }

  void openPdfInNewWindow(Uint8List pdf) {
    final blob = html.Blob([pdf], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final newWindow = html.window.open(url, '_blank');
  }

  /*static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }*/
}
