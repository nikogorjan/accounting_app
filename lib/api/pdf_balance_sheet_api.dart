import 'dart:convert';
import 'dart:io';
import 'package:accounting_app/api/pdf_api.dart';
import 'package:accounting_app/objekti/produkt_storitev.dart';
import 'package:accounting_app/objekti/stranka.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../objekti/invoice.dart';
import '../objekti/kont.dart';
import '../objekti/prodaja.dart';
import '../objekti/t_account.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PdfBalanceSheetApi {
  List<TAccount> tAccounts = [];
  List<Kont> konti = [];
  List<Kont> stalnaSredstva = [];
  List<Kont> gibljivaSredstva = [];
  List<Kont> obveznosti = [];
  List<Kont> kapital = [];
  List<Kont> prihodki = [];
  List<Kont> odhodki = [];
  pw.Document document = pw.Document();

  Future<void> createPdf() async {
    var myTheme = pw.ThemeData.withFont(
        base: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
        bold: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")));
    document = pw.Document(theme: myTheme);
    konti.sort(
      (a, b) => a.ID.compareTo(b.ID),
    );
    sortAccounts();
    buildRetainedEarnings();
    final table = pw.Table.fromTextArray(
      //context: context,
      data: [
        ['Account', 'Debit', 'Credit'],
        ...tAccounts.map((tAccount) => [
              tAccount.name,
              tAccount.debit.toString(),
              tAccount.credit.toString()
            ]),
        ['', '', ''],
        ['Total Assets', '${getTotalDebit()}', '${getTotalCredit()}'],
        ['', '', ''],
        [
          'Total Liabilities and Equity',
          '${getTotalDebit()}',
          '${getTotalCredit()}'
        ],
      ],
      cellStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
    );

    document.addPage(pw.MultiPage(
      build: (context) => [
        buildTitle(DateTime.now()),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        buildBalanceSheet(stalnaSredstva, gibljivaSredstva, obveznosti, kapital,
            prihodki, odhodki)
      ],
    ));

    stalnaSredstva = [];
    gibljivaSredstva = [];
    obveznosti = [];
    kapital = [];
    prihodki = [];
    odhodki = [];

    PdfApi.saveDocument(name: 'my_balance_sheet.pdf', pdf: document);
  }

  static pw.Widget buildTitle(DateTime date) => pw.Row(children: [
        pw.Expanded(child: pw.Column()),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              'Bilanca stanja',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
            pw.Text("${date.day}. ${date.month}. ${date.year}"),
            pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
          ],
        ),
        pw.Expanded(child: pw.Column()),
      ]);

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

  double getTotalDebit() {
    double total = 0;
    tAccounts.forEach((tAccount) {
      total += tAccount.debit;
    });
    return total;
  }

  double getTotalCredit() {
    double total = 0;
    tAccounts.forEach((tAccount) {
      total += tAccount.credit;
    });
    return total;
  }

  pw.Widget buildBalanceSheet(
    List<Kont> stalnaSredstva,
    List<Kont> gibljivaSredstva,
    List<Kont> obveznosti,
    List<Kont> kapital,
    List<Kont> prihodki,
    List<Kont> odhodki,
  ) =>
      pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Expanded(
          child: pw.Column(children: [
            buildAssets(stalnaSredstva, gibljivaSredstva),
            buildAssetSum(stalnaSredstva, gibljivaSredstva)
          ]),
        ),
        pw.VerticalDivider(),
        pw.Expanded(
            child: pw.Column(
          children: [
            buildLiabilitiesEquity(obveznosti, kapital),
            buildLiabilityEquitySum(obveznosti, kapital)
          ],
        ))
      ]);

  static pw.Widget buildAssets(
          List<Kont> stalnaSredstva, List<Kont> gibljivaSredstva) =>
      pw.Align(
          alignment: pw.Alignment.topCenter,
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                buildType(stalnaSredstva),
                buildType(gibljivaSredstva),
              ]));

  pw.Widget buildAssetSum(
          List<Kont> stalnaSredstva, List<Kont> gibljivaSredstva) =>
      pw.Column(children: [
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.black),
            ),
          ),
        ),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        pw.Row(children: [
          pw.Text(
            'SREDSTVA',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Spacer(),
          pw.Text(
            returnAssets(stalnaSredstva, gibljivaSredstva).toStringAsFixed(2),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ]),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.black),
            ),
          ),
        ),
      ]);

  pw.Widget buildLiabilityEquitySum(
    List<Kont> obveznosti,
    List<Kont> kapital,
  ) =>
      pw.Column(children: [
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.black),
            ),
          ),
        ),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        pw.Row(children: [
          pw.Text(
            'OBVEZNOSTI IN KAPITAL',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Spacer(),
          pw.Text(
            returnLiabilityEquity(obveznosti, kapital).toStringAsFixed(2),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ]),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.black),
            ),
          ),
        ),
      ]);

  double returnAssets(List<Kont> stalnaSredstva, List<Kont> gibljivaSredstva) {
    double sum = 0;
    for (int i = 0; i < stalnaSredstva.length; i++) {
      double debet = double.parse(stalnaSredstva[i].debet);
      double kredit = double.parse(stalnaSredstva[i].kredit);
      double vrednost;
      if (debet > kredit) {
        vrednost = debet - kredit;
      } else {
        vrednost = kredit - debet;
      }
      sum += vrednost;
    }

    for (int j = 0; j < gibljivaSredstva.length; j++) {
      double debet = double.parse(gibljivaSredstva[j].debet);
      double kredit = double.parse(gibljivaSredstva[j].kredit);
      double vrednost;
      if (debet > kredit) {
        vrednost = debet - kredit;
      } else {
        vrednost = kredit - debet;
      }
      sum += vrednost;
    }
    return sum;
  }

  double returnLiabilityEquity(
    List<Kont> obveznosti,
    List<Kont> kapital,
  ) {
    double sum = 0;
    for (int i = 0; i < obveznosti.length; i++) {
      double debet = double.parse(obveznosti[i].debet);
      double kredit = double.parse(obveznosti[i].kredit);
      double vrednost;
      if (debet > kredit) {
        vrednost = debet - kredit;
      } else {
        vrednost = kredit - debet;
      }
      sum += vrednost;
    }

    for (int j = 0; j < kapital.length; j++) {
      double debet = double.parse(kapital[j].debet);
      double kredit = double.parse(kapital[j].kredit);
      double vrednost;
      if (debet > kredit) {
        vrednost = debet - kredit;
      } else {
        vrednost = kredit - debet;
      }
      sum += vrednost;
    }
    return sum;
  }

  static pw.Widget buildLiabilitiesEquity(
    List<Kont> obveznosti,
    List<Kont> kapital,
  ) =>
      pw.Align(
          alignment: pw.Alignment.topCenter,
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                buildType(obveznosti),
                buildType(kapital),
              ]));

  static pw.Widget buildType(List<Kont> konti) {
    if (konti.length > 0) {
      final headers = [];
      String tip = konti[0].tip;
      headers.add(tip);

      double skupnaVrednost = 0;

      final data = konti.map((item) {
        double debet = double.parse(item.debet);
        double kredit = double.parse(item.kredit);
        double vrednost;
        if (debet > kredit) {
          vrednost = debet - kredit;
        } else {
          vrednost = kredit - debet;
        }
        skupnaVrednost += vrednost;
        return [item.ime, vrednost.toStringAsFixed(2)];
      }).toList();
      //data.add([' ', '________']);
      //data.add(
      //  ['   Skupaj ' + konti[0].tip, skupnaVrednost.toStringAsFixed(2)]);

      return pw.Column(children: [
        pw.Table.fromTextArray(
          headers: headers,
          data: data,
          border: null,
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
          //cellStyle: pw.TextStyle(font: ttf),
          cellHeight: 30,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
          },
        ),
        pw.Row(children: [
          pw.Spacer(),
          pw.Container(
            width: 2 * PdfPageFormat.cm,
            decoration: pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.black),
              ),
            ),
          ),
        ]),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        pw.Row(children: [
          pw.Text('    Skupaj ' + konti[0].tip),
          pw.Spacer(),
          pw.Text(skupnaVrednost.toStringAsFixed(2)),
        ]),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
      ]);
    } else {
      return pw.Text('');
    }
  }
}
