import 'package:accounting_app/gradniki/nadzorna_plosca/nadzorna_plosca_small_desktop.dart';
import 'package:accounting_app/gradniki/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:accounting_app/zasloni/screens.dart';
import '../data/data.dart';
import '../gradniki/banka/banka_desktop.dart';
import '../gradniki/delavci/delavci_desktop.dart';
import '../gradniki/glavna_knjiga/glavna_knjiga_desktop.dart';
import '../gradniki/inventar/inventar_desktop.dart';
import '../gradniki/nadzorna_plosca/nadzorna_plosca_desktop.dart';
import '../gradniki/porocila/porocila.dart';
import '../gradniki/prodaja/prodaja_desktop.dart';
import '../gradniki/projekti/projekti_desktop.dart';
import '../gradniki/stroski/stroski_desktop.dart';

class DashboardScreenSmallDesktop extends StatefulWidget {
  const DashboardScreenSmallDesktop({super.key});

  @override
  State<DashboardScreenSmallDesktop> createState() =>
      _DashboardScreenSmallDesktopState();
}

class _DashboardScreenSmallDesktopState
    extends State<DashboardScreenSmallDesktop> {
  List<Widget> menuScreens = [
    NadzornaPloscaSmallDesktop(),
    BankaDesktop(),
    ProdajaDesktop(),
    StroskiDesktop(),
    DelavciDesktop(),
    PorocilaDesktop(),
    InventarDesktop(),
    ProjektiDesktop(),
    GlavnaKnjigaDesktop()
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 370,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.all(15),
              width: 300,
              color: Color(0xEEEEEEEE).withOpacity(0.5),
              child: MenuNavigation(),
            ),
          ],
        ),
        Expanded(
          child: Container(
            //padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                //Flexible(flex: 2, child: Container()),
                Expanded(
                  child: Container(
                    //width: 820,
                    child: ListView(
                      //padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                      children: [
                        Container(
                          width: 100,
                          height: 50,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Spacer(),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                    },
                                    child: Text('izpis')),
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: global.menuIndex,
                          builder: ((context, value, child) {
                            return menuScreens[global.menuIndex.value];
                          }),
                        ),
                        //menuScreens[global.menuIndex],
                        //NadzornaPloscaDesktop(),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
                //Flexible(flex: 2, child: Container()),
              ],
            ),
          ),
        )
      ],
    );
  }
}
