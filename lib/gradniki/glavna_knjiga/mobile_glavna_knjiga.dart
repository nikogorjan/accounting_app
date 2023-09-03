import 'package:accounting_app/gradniki/glavna_knjiga/account_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import 'account_form_mobile.dart';
import 'dnevnik_mobile.dart';
import 'journal_entry_form.dart';
import 'journal_entry_form_mobile.dart';
import 'kontni_nacrt_mobile.dart';

class GlavnaKnjigaMobile extends StatefulWidget {
  const GlavnaKnjigaMobile({super.key});

  @override
  State<GlavnaKnjigaMobile> createState() => _GlavnaKnjigaMobileState();
}

class _GlavnaKnjigaMobileState extends State<GlavnaKnjigaMobile> {
  List<Widget> GKmenu = [KontniNacrtMobile(), DnevnikMobile()];

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
                    'Glavna knjiga',
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
                          global.glavnaKnjigaIndex.value = 0;
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Kontni načrt',
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
                          global.glavnaKnjigaIndex.value = 1;
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(
                  height: 20,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: global.glavnaKnjigaIndex,
                builder: ((context, value, child) {
                  return GKmenu[global.glavnaKnjigaIndex.value];
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
              if (global.glavnaKnjigaIndex.value == 0) {
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
              }
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
