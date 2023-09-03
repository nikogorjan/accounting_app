import 'package:accounting_app/gradniki/prodaja/prodaja_racuni.dart';
import 'package:accounting_app/gradniki/prodaja/produkti_storitve.dart';
import 'package:accounting_app/gradniki/prodaja/stranke.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../data/data.dart';

class ProdajaDesktop extends StatefulWidget {
  const ProdajaDesktop({super.key});

  @override
  State<ProdajaDesktop> createState() => _ProdajaDesktopState();
}

class _ProdajaDesktopState extends State<ProdajaDesktop> {
  List<Widget> GKmenu = [ProdajaRacuni(), Stranke(), ProduktiStoritve()];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Prodaja',
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 36),
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
                      global.prodajaIndex.value = 0;
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Računi',
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
                      global.prodajaIndex.value = 1;
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Stranke',
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
                      global.prodajaIndex.value = 2;
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Produkti in storitve',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 24,
                              color: Colors.black)),
                    )),
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
            valueListenable: global.prodajaIndex,
            builder: ((context, value, child) {
              return GKmenu[global.prodajaIndex.value];
            }),
          ),
        ],
      ),
    );
  }
}
