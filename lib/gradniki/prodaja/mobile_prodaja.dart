import 'package:accounting_app/gradniki/prodaja/prodaja_dodaj_racun_mobile.dart';
import 'package:accounting_app/gradniki/prodaja/prodaja_racuni_mobile.dart';
import 'package:accounting_app/gradniki/prodaja/produkti_storitve_mobile.dart';
import 'package:accounting_app/gradniki/prodaja/stranke_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:accounting_app/gradniki/glavna_knjiga/account_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../glavna_knjiga/account_form_mobile.dart';
import '../glavna_knjiga/journal_entry_form_mobile.dart';

class ProdajaMobile extends StatefulWidget {
  const ProdajaMobile({super.key});

  @override
  State<ProdajaMobile> createState() => _ProdajaMobileState();
}

class _ProdajaMobileState extends State<ProdajaMobile> {
  List<Widget> GKmenu = [
    ProdajaRacuniMobile(),
    StrankeMobile(),
    ProduktiStoritveMobile()
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          //height: MediaQuery.of(context).size.height - 80,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Prodaja',
                    style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    child: TextButton(
                        onPressed: () {
                          global.prodajaIndex.value = 0;
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Računi',
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 18,
                                  color: Colors.black)),
                        )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 50,
                    child: TextButton(
                        onPressed: () {
                          global.prodajaIndex.value = 1;
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Stranke',
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 18,
                                  color: Colors.black)),
                        )),
                  ),
                  Container(
                    height: 50,
                    child: TextButton(
                        onPressed: () {
                          global.prodajaIndex.value = 2;
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Produkti in storitve',
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 18,
                                  color: Colors.black)),
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(
                  height: 20,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: global.prodajaIndex,
                builder: ((context, value, child) {
                  return GKmenu[global.prodajaIndex.value];
                }),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              if (global.prodajaIndex.value == 0) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(content: ProdajaDodajRacunMobile());
                    });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(content: JournalEntryFormMobile());
                    });
              }
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
