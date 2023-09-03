import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../data/data.dart';
import '../gradniki/banka/mobile_banka.dart';
import '../gradniki/delavci/mobile_delavci.dart';
import '../gradniki/glavna_knjiga/mobile_glavna_knjiga.dart';
import '../gradniki/inventar/mobile_inventar.dart';
import '../gradniki/nadzorna_plosca/nadzorna_plosca_mobile.dart';
import '../gradniki/porocila/mobile_porocila.dart';
import '../gradniki/prodaja/mobile_prodaja.dart';
import '../gradniki/projekti/mobile_projekti.dart';
import '../gradniki/stroski/mobile_stroski.dart';

class DashboardScreenMobile extends StatefulWidget {
  const DashboardScreenMobile({super.key});

  @override
  State<DashboardScreenMobile> createState() => _DashboardScreenMobileState();
}

class _DashboardScreenMobileState extends State<DashboardScreenMobile> {
  final user = FirebaseAuth.instance.currentUser!;
  bool isDrawerOpen = false;
  List<Widget> menuScreens = [
    NadzornaPloscaMobile(),
    BankaMobile(),
    ProdajaMobile(),
    StroskiMobile(),
    DelavciMobile(),
    PorocilaMobile(),
    InventarMobile(),
    ProjektiMobile(),
    GlavnaKnjigaMobile()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          children: [
            Container(
              height: 60,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: ImageIcon(
                      AssetImage('lib/sredstva/menu.png'),
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: global.menuIndex,
              builder: ((context, value, child) {
                return menuScreens[global.menuIndex.value];
              }),
            ),
          ],
        ),
      ),
    );
  }
}
