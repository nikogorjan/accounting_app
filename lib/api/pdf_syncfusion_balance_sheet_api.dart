import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:accounting_app/api/pdf_api.dart';
import 'package:accounting_app/api/pdf_sync_api.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../objekti/kont.dart';
import '../objekti/t_account.dart';
import 'package:universal_html/html.dart' as html;

class BalanceSheetApi {
  List<TAccount> tAccounts = [];
  List<Kont> konti = [];
  List<Kont> stalnaSredstva = [];
  List<Kont> gibljivaSredstva = [];
  List<Kont> obveznosti = [];
  List<Kont> kapital = [];
  List<Kont> prihodki = [];
  List<Kont> odhodki = [];

  final PdfDocument document = PdfDocument();

  Future<void> createPDF() async {
    //Create a PDF document.
    PdfDocument document = PdfDocument();

    //Add a page and draw text
    document.pages.add().graphics.drawString(
        'Hello Worlč!', PdfStandardFont(PdfFontFamily.timesRoman, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(20, 60, 150, 30));
    //Save the document
    List<int> bytes = await document.save();
    //Dispose the document
    document.dispose();

    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "output.pdf")
      ..click();
  }

  Future<void> createPdf() async {
    konti.sort(
      (a, b) => a.ID.compareTo(b.ID),
    );
    sortAccounts();
    buildRetainedEarnings();
    final PdfPage page = document.pages.add();
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);

    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);

//Add header to the grid
    grid.headers.add(1);

//Add the rows to the grid
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'RollNo';
    header.cells[1].value = 'Name';
    header.cells[2].value = 'Class';

//Add rows to grid
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = '1';
    row.cells[1].value = 'Arya';
    row.cells[2].value = '6';
    row = grid.rows.add();
    row.cells[0].value = '12';
    row.cells[1].value = 'John';
    row.cells[2].value = '9';
    row = grid.rows.add();
    row.cells[0].value = '42';
    row.cells[1].value = 'Tony';
    row.cells[2].value = '8';

//Draw grid to the page of the PDF document
    grid.draw(page: document.pages.add(), bounds: Rect.fromLTWH(0, 0, 0, 0));

    //PdfSyncApi.saveDocument(name: 'my_balance_sheet.pdf', pdf: document);
    final bytes = await document.save();
    late Directory dir;
    var file = File('');
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final newWindow = html.window.open(url, '_blank');
  }

  void sortAccounts() {
    for (int i = 0; i < konti.length; i++) {
      if (konti[i].tip == 'Stalna sredstva') {
        stalnaSredstva.add(konti[i]);
      } else if (konti[i].tip == 'Gibljiva sredstva') {
        gibljivaSredstva.add(konti[i]);
      } else if (konti[i].tip == 'Obveznosti') {
        obveznosti.add(konti[i]);
      } else if (konti[i].tip == 'Kapital') {
        kapital.add(konti[i]);
      } else if (konti[i].tip == 'Prihodki') {
        prihodki.add(konti[i]);
      } else if (konti[i].tip == 'Odhodki') {
        odhodki.add(konti[i]);
      }
    }
  }

  void buildRetainedEarnings() {
    double retainedValue = 0;
    for (int i = 0; i < prihodki.length; i++) {
      retainedValue += double.parse(prihodki[i].bilanca).abs();
    }
    for (int j = 0; j < odhodki.length; j++) {
      retainedValue -= double.parse(odhodki[j].bilanca).abs();
    }
    Kont retainedEarnings = Kont(
        ID: 'ID',
        ime: 'Zadržani dobiček',
        tip: 'tip',
        podtip: 'podtip',
        bilanca: retainedValue.toString(),
        amortizacija: 'amortizacija',
        bilancaDate: 'bilancaDate',
        amortizacijaDate: 'amortizacijaDate',
        debet: retainedValue.toString(),
        kredit: 0.toString());

    kapital.add(retainedEarnings);
  }
}
