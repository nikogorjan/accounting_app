import 'package:accounting_app/gradniki/projekti/planiranje_storitev.dart';
import 'package:accounting_app/gradniki/projekti/planiranje_storitev_mobile.dart';
import 'package:accounting_app/gradniki/projekti/proizvodnja_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import 'add_plan_form.dart';
import 'add_projekt_form.dart';

class ProjektiMobile extends StatefulWidget {
  const ProjektiMobile({super.key});

  @override
  State<ProjektiMobile> createState() => _ProjektiMobileState();
}

class _ProjektiMobileState extends State<ProjektiMobile> {
  List<Widget> GKmenu = [ProizvodnjaMobile(), PlaniranjeStoritevMobile()];

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
                    'Projekti',
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
                          global.projektiIndex.value = 0;
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Proizvodnja',
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
                          global.projektiIndex.value = 1;
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Planiranje storitev',
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
                valueListenable: global.projektiIndex,
                builder: ((context, value, child) {
                  return GKmenu[global.projektiIndex.value];
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
                      return AlertDialog(content: AddProjektForm());
                    });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(content: AddPlanForm());
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
