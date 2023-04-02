import 'dart:convert';
import 'dart:io';
import 'package:accounting_app/api/pdf_api.dart';
import 'package:accounting_app/objekti/produkt_storitev.dart';
import 'package:accounting_app/objekti/stranka.dart';
import 'package:accounting_app/objekti/vnos_v_dnevnik.dart';
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

class PdfIncomeStatement {
  late DateTime date1;
  late DateTime date2;
  pw.Document document = pw.Document();
  List<Kont> konti = [];
  List<VnosVDnevnik> vnosiVDnevnik = [];
  List<Kont> prihodkiOdhodki = [];
  List<Kont> poslovniPrihodki = [];
  List<Kont> financniPrihodki = [];
  List<Kont> poslovniOdhodki = [];
  List<Kont> financniOdhodki = [];
  List<Kont> drugiPrihodki = [];

  List<Kont> drugiOdhodki = [];

  Future<void> createPdf() async {
    separateIncomeandExpenses();
    buildAccountsBasedOnDates();
    sortAccounts();
    var myTheme = pw.ThemeData.withFont(
        base: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
        bold: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")));
    document = pw.Document(theme: myTheme);

    document.addPage(pw.MultiPage(
      build: (context) => [
        buildTitle(date1, date2),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        buildIncomeStatement(prihodkiOdhodki),
      ],
    ));

    PdfApi.saveDocument(name: 'my_balance_sheet.pdf', pdf: document);
  }

  static pw.Widget buildTitle(DateTime date1, DateTime date2) =>
      pw.Row(children: [
        pw.Expanded(child: pw.Column()),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              'Izkaz poslovnega izida',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
            pw.Text(
                "${date1.day}. ${date1.month}. ${date1.year} - ${date2.day}. ${date2.month}. ${date2.year}"),
            pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
          ],
        ),
        pw.Expanded(child: pw.Column()),
      ]);

  void separateIncomeandExpenses() {
    for (int i = 0; i < konti.length; i++) {
      if (konti[i].tip == 'Prihodki' || konti[i].tip == 'Odhodki') {
        prihodkiOdhodki.add(Kont(
            ID: konti[i].ID,
            ime: konti[i].ime,
            tip: konti[i].tip,
            podtip: konti[i].podtip,
            bilanca: '0',
            amortizacija: 'amortizacija',
            bilancaDate: 'bilancaDate',
            amortizacijaDate: 'amortizacijaDate',
            debet: '0',
            kredit: '0'));
      }
    }
  }

  bool isDateInRange(DateTime date, DateTime startDate, DateTime endDate) {
    return date.isAfter(startDate.subtract(Duration(days: 1))) &&
        date.isBefore(endDate.add(Duration(days: 1)));
  }

  void buildAccountsBasedOnDates() {
    for (int i = 0; i < vnosiVDnevnik.length; i++) {
      for (int j = 0; j < prihodkiOdhodki.length; j++) {
        if (isDateInRange(
            DateTime.parse(vnosiVDnevnik[i].datum), date1, date2)) {
          if (prihodkiOdhodki[j].ime == vnosiVDnevnik[i].kontDebet) {
            Kont old = prihodkiOdhodki[j];
            prihodkiOdhodki[j] = Kont(
                ID: old.ID,
                ime: old.ime,
                tip: old.tip,
                podtip: old.podtip,
                bilanca: (double.parse(vnosiVDnevnik[i].debet) +
                        double.parse(old.bilanca))
                    .toString(),
                amortizacija: old.amortizacija,
                bilancaDate: old.bilancaDate,
                amortizacijaDate: old.amortizacijaDate,
                debet: (double.parse(vnosiVDnevnik[i].debet) +
                        double.parse(old.debet))
                    .toString(),
                kredit: old.kredit);
          } else if (prihodkiOdhodki[j].ime == vnosiVDnevnik[i].kontKredit) {
            Kont old = prihodkiOdhodki[j];
            prihodkiOdhodki[j] = Kont(
                ID: old.ID,
                ime: old.ime,
                tip: old.tip,
                podtip: old.podtip,
                bilanca: (double.parse(old.bilanca) -
                        double.parse(vnosiVDnevnik[i].kredit))
                    .toString(),
                amortizacija: old.amortizacija,
                bilancaDate: old.bilancaDate,
                amortizacijaDate: old.amortizacijaDate,
                debet: old.debet,
                kredit: (double.parse(vnosiVDnevnik[i].kredit) +
                        double.parse(old.kredit))
                    .toString());
          }
        }
      }
    }
  }

  void sortAccounts() {
    for (int i = 0; i < prihodkiOdhodki.length; i++) {
      if (prihodkiOdhodki[i].podtip == 'Poslovni prihodki') {
        poslovniPrihodki.add(prihodkiOdhodki[i]);
      } else if (prihodkiOdhodki[i].podtip == 'Finančni prihodki') {
        financniPrihodki.add(prihodkiOdhodki[i]);
      } else if (prihodkiOdhodki[i].podtip == 'Izredni prihodki') {
        drugiPrihodki.add(prihodkiOdhodki[i]);
      } else if (prihodkiOdhodki[i].podtip == 'Poslovni odhodki') {
        poslovniOdhodki.add(prihodkiOdhodki[i]);
      } else if (prihodkiOdhodki[i].podtip == 'Prevrednotovalni odhodki') {
        drugiOdhodki.add(prihodkiOdhodki[i]);
      } else if (prihodkiOdhodki[i].podtip == 'Finančni odhodki') {
        financniOdhodki.add(prihodkiOdhodki[i]);
      } else if (prihodkiOdhodki[i].podtip == 'Izredni odhodki') {
        drugiOdhodki.add(prihodkiOdhodki[i]);
      }
    }
  }

  pw.Widget buildIncomeStatement(List<Kont> prihodkiOdhodki) =>
      pw.Column(children: [
        buildRevenueExpenses(poslovniPrihodki),
        buildRevenueExpenses(poslovniOdhodki),
        buildRevenueExpensesSum(poslovniPrihodki, poslovniOdhodki),
        buildRevenueExpenses(financniPrihodki),
        buildRevenueExpenses(financniOdhodki),
        buildRevenueExpenses(drugiPrihodki),
        buildRevenueExpenses(drugiOdhodki),
      ]);

  static pw.Widget buildRevenueExpenses(List<Kont> konti) {
    if (konti.length > 0) {
      final headers = [];
      String tip = konti[0].podtip;
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
          pw.Text('    Skupaj '),
          pw.Spacer(),
          pw.Text(skupnaVrednost.toStringAsFixed(2)),
        ]),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
      ]);
    } else {
      return pw.Text('');
    }
  }

  double rednoDelovanje = 0;
  double poslovanje = 0;
  double celotniDobicek = 0;

  pw.Widget buildRevenueExpensesSum(List<Kont> prihodki, List<Kont> odhodki) {
    if (prihodki.length == 0 && odhodki.length == 0) {
      return pw.Text('');
    } else {
      double prihodkiSkupaj = 0;
      double odhodkiSkupaj = 0;
      for (int i = 0; i < prihodki.length; i++) {
        double debet = double.parse(prihodki[i].debet);
        double kredit = double.parse(prihodki[i].kredit);
        double vrednost;
        if (debet > kredit) {
          vrednost = debet - kredit;
        } else {
          vrednost = kredit - debet;
        }
        prihodkiSkupaj += vrednost;
      }

      for (int j = 0; j < odhodki.length; j++) {
        double debet = double.parse(odhodki[j].debet);
        double kredit = double.parse(odhodki[j].kredit);
        double vrednost;
        if (debet > kredit) {
          vrednost = debet - kredit;
        } else {
          vrednost = kredit - debet;
        }
        odhodkiSkupaj += vrednost;
      }

      double skupnaVrednost = prihodkiSkupaj - odhodkiSkupaj;
      String tip = '';
      if (prihodki[0].podtip == 'Poslovni prihodki') {
        tip = 'Dobiček iz poslovanja';
        poslovanje = skupnaVrednost;
      } else if (prihodki[0].podtip == 'Finančni prihodki') {
        tip = 'Dobiček iz rednega delovanja';
        rednoDelovanje = skupnaVrednost;
      } else {
        tip = 'Celotni dobiček';
        celotniDobicek = skupnaVrednost;
      }

      return pw.Container(
        padding: pw.EdgeInsets.fromLTRB(10, 0, 10, 0),
        color: PdfColors.blue100,
        height: 30,
        child: pw.Row(children: [
          pw.Text(tip, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Spacer(),
          pw.Text(skupnaVrednost.toStringAsFixed(2),
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ]),
      );
    }
  }
}
