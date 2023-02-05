import 'package:accounting_app/gradniki/glavna_knjiga/dnevnik.dart';
import 'package:accounting_app/gradniki/glavna_knjiga/kontni_nacrt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../data/data.dart';

class GlavnaKnjigaDesktop extends StatefulWidget {
  const GlavnaKnjigaDesktop({super.key});

  @override
  State<GlavnaKnjigaDesktop> createState() => _GlavnaKnjigaDesktopState();
}

class _GlavnaKnjigaDesktopState extends State<GlavnaKnjigaDesktop> {
  List<Widget> GKmenu = [KontniNacrt(), Dnevnik()];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Glavna Knjiga',
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
                      global.glavnaKnjigaIndex.value = 0;
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Kontni načrt',
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
                      global.glavnaKnjigaIndex.value = 1;
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
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
    );
  }
}
