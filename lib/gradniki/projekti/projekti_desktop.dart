import 'dart:convert';

import 'package:accounting_app/gradniki/projekti/add_projekt_button.dart';
import 'package:accounting_app/gradniki/projekti/planiranje_storitev.dart';
import 'package:accounting_app/gradniki/projekti/proizvodnja.dart';
import 'package:accounting_app/gradniki/projekti/projekt_card.dart';
import 'package:accounting_app/objekti/projekt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../data/data.dart';

class ProjektiDesktop extends StatefulWidget {
  const ProjektiDesktop({super.key});

  @override
  State<ProjektiDesktop> createState() => _ProjektiDesktopState();
}

class _ProjektiDesktopState extends State<ProjektiDesktop> {
  List<Widget> GKmenu = [Proizvodnja(), PlaniranjeStoritev()];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                'Projekti',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 36),
              ),
            ),
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
                      child: Text('Proizvodjnja',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 24,
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
                              fontSize: 24,
                              color: Colors.black)),
                    )),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
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
    );
  }
}
