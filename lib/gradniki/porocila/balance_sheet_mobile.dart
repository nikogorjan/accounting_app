import 'dart:convert';
import 'dart:io';

import 'package:accounting_app/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../api/pdf_balance_sheet_api.dart';
import '../../api/pdf_syncfusion_balance_sheet_api.dart';
import '../../data/data.dart';
import '../../objekti/kont.dart';
import '../../objekti/t_account.dart';
import 'income_statement_form.dart';
import 'income_statement_form_mobile.dart';

class BalanceSheetMobile extends StatefulWidget {
  const BalanceSheetMobile({super.key});

  @override
  State<BalanceSheetMobile> createState() => _BalanceSheetMobileState();
}

class _BalanceSheetMobileState extends State<BalanceSheetMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    'Bilanca stanja',
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Bilanca stanja nam pokaže na določen dan obračunskega obdobja\npremožensko sliko podjetja in je sestavljena v dvostopenski\nobliki - Ima dve med seboj uravnoteženi strani.\n\nNa eni strani bilance stanja so sredstva razvrščena po hitrosti\nobračanja med stalna in gibljiva. Na drugi strani so so postavke\nrazvrščene po obliki obveznosti do virov sredstev na kapital in\ndolgove. Temeljno načelo je, da lahko podjetje razpolaga le z\ntolikšnimi sredstvi, kolikor znašajo obveznosti zanje.',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              ConstrainedBox(
                constraints:
                    const BoxConstraints.tightFor(width: 150, height: 50),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0)),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                          color: Colors.white))),
                  onPressed: () {
                    List<Kont> accounts = [];
                    PdfBalanceSheetApi balanceSheetApi = PdfBalanceSheetApi();
                    BalanceSheetApi api = BalanceSheetApi();
                    var db = FirebaseFirestore.instance;
                    String ID = box.get('email');
                    final docRef = db.collection("Users").doc(ID);
                    docRef.get().then((DocumentSnapshot doc) async {
                      final data = doc.data() as Map<String, dynamic>;
                      List<dynamic> accountsJson = data['konti'];

                      for (int i = 0; i < accountsJson.length; i++) {
                        Map<String, dynamic> valueMap =
                            json.decode(accountsJson[i]);
                        Kont NewAccount = Kont.fromJson(valueMap);
                        accounts.add(NewAccount);
                      }

                      for (int i = 0; i < accounts.length; i++) {
                        balanceSheetApi.tAccounts.add(TAccount(
                            name: accounts[i].ime,
                            debit: double.parse(accounts[i].debet),
                            credit: double.parse(accounts[i].kredit)));
                      }
                      balanceSheetApi.konti = accounts;
                      balanceSheetApi.createPdf();

                      path = await box.get('data');
                      int i = 0;

                      Storage storage = Storage();
                      final url = await storage.UploadFileMobilePdf(
                          path, 'name', box.get('email'));
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PdfViewerPage(url: url),
                        ),
                      );
                      //api.createPDF();
                    });
                  },
                  child: Text(
                    'Generiraj',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Izkaz poslovnega izida',
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Izkaz poslovnega izida je temeljni računovodski izkaz, ki prikazuje,\nkoliko prihodkov je podjetje ustvarilo, koliko je bilo odhodkov\nin kakšen je poslovni izid v poslovnem letu ali drugem poslovnem\nobdobju.',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              ConstrainedBox(
                constraints:
                    const BoxConstraints.tightFor(width: 150, height: 50),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0)),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                          color: Colors.white))),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              //title: Text('Dodaj kont'),
                              content: IncomeStatementFormMobile(),
                            )));
                  },
                  child: Text(
                    'Generiraj',
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

String path = '';

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfPdfViewer.network(
      path,
    ));
  }
}

void _openNewScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NewScreen(),
    ),
  );
}

class PdfViewerPage extends StatelessWidget {
  final String url;

  const PdfViewerPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: SfPdfViewer.network(
        url,
        canShowScrollHead: false,
      ),
    );
  }
}
