import 'package:accounting_app/gradniki/delavci/izdaja_plac.dart';
import 'package:accounting_app/gradniki/delavci/zaposleni.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../data/data.dart';
import 'delavci_dnevnik.dart';

class DelavciDesktop extends StatefulWidget {
  const DelavciDesktop({super.key});

  @override
  State<DelavciDesktop> createState() => _DelavciDesktopState();
}

class _DelavciDesktopState extends State<DelavciDesktop> {
  List<Widget> GKmenu = [Zaposleni(), DelavciDnevnik(), IzdajaPlac()];

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
                'Delavci',
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
                      global.delavciIndex.value = 0;
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Zaposleni',
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
                      global.delavciIndex.value = 1;
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Dnevnik',
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
                      global.delavciIndex.value = 2;
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Izdaja plač',
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
            valueListenable: global.delavciIndex,
            builder: ((context, value, child) {
              return GKmenu[global.delavciIndex.value];
            }),
          ),
        ],
      ),
    );
  }
}
