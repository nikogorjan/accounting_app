import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:universal_html/html.dart' as html;

class PdfApi {
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
      file = File('${dir.path}/$name');

      await file.writeAsBytes(bytes);
    }

    return file;
  }

  void openPdfInNewWindow(Uint8List pdf) {
    final blob = html.Blob([pdf], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final newWindow = html.window.open(url, '_blank');
  }
}
