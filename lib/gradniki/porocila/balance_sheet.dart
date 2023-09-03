import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import '../../api/pdf_balance_sheet_api.dart';
import '../../api/pdf_syncfusion_balance_sheet_api.dart';
import '../../data/data.dart';
import '../../objekti/kont.dart';
import '../../objekti/t_account.dart';
import 'income_statement_form.dart';

class BalanceSheet extends StatefulWidget {
  const BalanceSheet({
    super.key,
  });

  @override
  State<BalanceSheet> createState() => _BalanceSheetState();
}

class _BalanceSheetState extends State<BalanceSheet> {
  //PdfBalanceSheetApi balanceSheetApi = PdfBalanceSheetApi();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              //width: 750,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Bilanca stanja',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 32),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Bilanca stanja nam pokaže na določen dan obračunskega obdobja premožensko sliko podjetja in je sestavljena v dvostopenski\nobliki - Ima dve med seboj uravnoteženi strani.\n\nNa eni strani bilance stanja so sredstva razvrščena po hitrosti obračanja med stalna in gibljiva. Na drugi strani so so postavke\nrazvrščene po obliki obveznosti do virov sredstev na kapital in dolgove. Temeljno načelo je, da lahko podjetje razpolaga le z\ntolikšnimi sredstvi, kolikor znašajo obveznosti zanje.',
                        style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 150, height: 50),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0)),
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 16,
                                      color: Colors.white))),
                          onPressed: () {
                            List<Kont> accounts = [];
                            PdfBalanceSheetApi balanceSheetApi =
                                PdfBalanceSheetApi();
                            BalanceSheetApi api = BalanceSheetApi();
                            var db = FirebaseFirestore.instance;
                            String ID = box.get('email');
                            final docRef = db.collection("Users").doc(ID);
                            docRef.get().then((DocumentSnapshot doc) {
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
                            fontSize: 32),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Izkaz poslovnega izida je temeljni računovodski izkaz, ki prikazuje, koliko prihodkov je podjetje ustvarilo, koliko je bilo odhodkov\nin kakšen je poslovni izid v poslovnem letu ali drugem poslovnem obdobju.',
                        style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 150, height: 50),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(0)),
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 16,
                                      color: Colors.white))),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: ((context) => AlertDialog(
                                      //title: Text('Dodaj kont'),
                                      content: IncomeStatementForm(),
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
            ),

            //Spacer(),
          ],
        ),

        /*StreamBuilder(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  List<dynamic> accountsJson = data['konti'];
                  List<Kont> accounts = [];
                  for (int i = 0; i < accountsJson.length; i++) {
                    Map<String, dynamic> valueMap =
                        json.decode(accountsJson[i]);
                    Kont NewAccount = Kont.fromJson(valueMap);
                    accounts.add(NewAccount);
                  }
                  accounts.sort(
                    (a, b) => a.ID.compareTo(b.ID),
                  );
                  return Column(
                    children: [
                      for (int i = 0; i < accounts.length; i++) ...[
                        AccountRow(
                          ID: accounts[i].ID,
                          ime: accounts[i].ime,
                          tip: accounts[i].tip,
                          podtip: accounts[i].podtip,
                          bilanca: accounts[i].bilanca,
                          amortizacija: accounts[i].amortizacija,
                        ),
                        Divider(
                          height: 1,
                        )
                      ],
                    ],
                  );
                }).toList(),
              );
            }),*/
      ]),
    );
  }
}
