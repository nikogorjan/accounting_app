import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'balance_sheet.dart';

class PorocilaDesktop extends StatefulWidget {
  const PorocilaDesktop({super.key});

  @override
  State<PorocilaDesktop> createState() => _PorocilaDesktopState();
}

class _PorocilaDesktopState extends State<PorocilaDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Poročila',
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
                      //global.glavnaKnjigaIndex.value = 0;
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Poročila',
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
          BalanceSheet()
          /*ValueListenableBuilder(
            valueListenable: global.glavnaKnjigaIndex,
            builder: ((context, value, child) {
              return GKmenu[global.glavnaKnjigaIndex.value];
            }),
          ),*/
        ],
      ),
    );
  }
}
