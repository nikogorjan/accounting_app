import 'dart:convert';
import 'dart:io';
import 'package:accounting_app/api/pdf_api.dart';
import 'package:accounting_app/objekti/produkt_storitev.dart';
import 'package:accounting_app/objekti/stranka.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../data/data.dart';
import '../objekti/invoice.dart';
import '../objekti/prodaja.dart';
import '../services/storage_service.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

class PdfInvoiceApi {
  Storage storage = Storage();
  String getLogo() {
    String url = '';
    storage.getData(
        'users', box.get('email') + '/images/' + '_Logotip' + '.png');
    return url;
  }

  //String logotip = '';

  static Future<File> generate(Invoice invoice, String logotip) async {
    Document pdf = Document();

    var myTheme = ThemeData.withFont(
        base: Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
        bold: Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")));

    pdf = Document(theme: myTheme);
    final netImage = await networkImage(logotip);
    //var response = await http.get(Uri.parse(logotip));
    //var imageData = response.bodyBytes;
    /*var pdfImage = PdfImage.file(
      pdf.document,
      bytes: imageData,
    );

    var imageProvider = MemoryImage(imageData);*/

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice, netImage),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      //footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RACUN',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text('ID: ' + invoice.ID),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildHeader(Invoice invoice, ImageProvider logotip) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice),
              Container(
                height: 100,
                width: 100,
                child: Image(logotip),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice),
              buildInvoiceInfo(invoice),
            ],
          ),
        ],
      );

  static Widget buildSupplierAddress(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(invoice.izdajateljIme,
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(invoice.sedezPodjetja),
        ],
      );

  static Widget buildCustomerAddress(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(invoice.stranka.naziv,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(invoice.stranka.naslov),
        ],
      );

  static Widget buildInvoiceInfo(Invoice invoice) {
    final titles = <String>['Datum:', 'Rok placila:'];
    final data = <String>[
      "${DateTime.parse(invoice.racun.datum).day}. ${DateTime.parse(invoice.racun.datum).month}. ${DateTime.parse(invoice.racun.datum).year}",
      "${DateTime.parse(invoice.racun.rokPlacila).day}. ${DateTime.parse(invoice.racun.rokPlacila).month}. ${DateTime.parse(invoice.racun.rokPlacila).year}",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Produkt/storitev',
      'Datum',
      'Kolicina',
      'Cena',
      'DDV',
      'Vsota'
    ];

    List<dynamic> itemsString = invoice.racun.prodaje;
    List<Prodaja> items = [];
    for (int i = 0; i < itemsString.length; i++) {
      Map<String, dynamic> valueMap = json.decode(itemsString[i]);

      items.add(Prodaja.fromJson(valueMap));
    }
    final data = items.map((item) {
      final total = item.vsota;

      return [
        item.PS,
        "${DateTime.parse(invoice.racun.datum).day}. ${DateTime.parse(invoice.racun.datum).month}. ${DateTime.parse(invoice.racun.datum).year}",
        '${item.kolicina}',
        '${item.cena}',
        '${item.DDV}%',
        '${item.vsota}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    List<dynamic> itemsString = invoice.racun.prodaje;
    List<Prodaja> items = [];
    for (int i = 0; i < itemsString.length; i++) {
      Map<String, dynamic> valueMap = json.decode(itemsString[i]);

      items.add(Prodaja.fromJson(valueMap));
    }

    double netTotal = 0;
    for (int j = 0; j < items.length; j++) {
      netTotal += double.parse(items[j].kolicina as String) *
          double.parse(items[j].cena);
    }

    //final netTotal = invoice.racun.bilanca;
    //final vatPercent = invoice.items.first.vat;
    //final vat = netTotal * vatPercent;
    //final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Neto Skupaj',
                  value: netTotal.toStringAsFixed(2),
                  unite: true,
                ),
                /*buildText(
                  title: 'Vat ${vatPercent * 100} %',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),*/
                Divider(),
                buildText(
                  title: 'Skupni znesek',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: invoice.racun.bilanca,
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
