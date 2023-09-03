import 'package:accounting_app/gradniki/delavci/izdaja_plac_mobile.dart';
import 'package:accounting_app/gradniki/delavci/zaposleni_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import 'delavci_dnevnik_mobile.dart';

class DelavciMobile extends StatefulWidget {
  const DelavciMobile({super.key});

  @override
  State<DelavciMobile> createState() => _DelavciMobileState();
}

class _DelavciMobileState extends State<DelavciMobile> {
  List<Widget> GKmenu = [
    ZaposleniMobile(),
    DelavciDnevnikMobile(),
    IzdajaPlacMobile()
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
                    'Delavci',
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
                          global.delavciIndex.value = 0;
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Zaposleni',
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
                          global.delavciIndex.value = 1;
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Dnevnik',
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
                          global.delavciIndex.value = 2;
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Izdaja plač',
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
                valueListenable: global.delavciIndex,
                builder: ((context, value, child) {
                  return GKmenu[global.delavciIndex.value];
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
              /*if (global.glavnaKnjigaIndex.value == 0) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(content: AccountFormMobile());
                    });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(content: JournalEntryFormMobile());
                    });
              }*/
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
