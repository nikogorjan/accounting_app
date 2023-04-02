//import 'dart:ffi';
import 'package:accounting_app/gradniki/banka/banka_desktop.dart';
import 'package:accounting_app/gradniki/delavci/delavci_desktop.dart';
import 'package:accounting_app/gradniki/glavna_knjiga/glavna_knjiga_desktop.dart';
import 'package:accounting_app/gradniki/inventar/inventar_desktop.dart';
import 'package:accounting_app/gradniki/nadzorna_plosca/nadzorna_plosca_desktop.dart';
import 'package:accounting_app/gradniki/porocila/porocila.dart';
import 'package:accounting_app/gradniki/prodaja/prodaja_desktop.dart';
import 'package:accounting_app/gradniki/projekti/projekti_desktop.dart';
import 'package:accounting_app/gradniki/stroski/stroski_desktop.dart';
import 'package:accounting_app/gradniki/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:accounting_app/data/data.dart';

class DashboardScreenDesktop extends StatefulWidget {
  const DashboardScreenDesktop({super.key});

  @override
  State<DashboardScreenDesktop> createState() => _DashboardScreenDesktopState();
}

class _DashboardScreenDesktopState extends State<DashboardScreenDesktop> {
  final user = FirebaseAuth.instance.currentUser!;
  List<Widget> menuScreens = [
    NadzornaPloscaDesktop(),
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      right: BorderSide(
                          color: Color(0xEEEEEEEE).withOpacity(0.5),
                          width: 2))),
              //color: Colors.white, //Color(0xEEEEEEEE).withOpacity(0.5),
              child: MenuNavigation(),
            ),
          ],
        ),
        Expanded(
          child: Container(
            //padding: const EdgeInsets.fromLTRB(300, 0, 0, 0),
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                //Flexible(flex: 2, child: Container()),
                Expanded(
                  child: Container(
                    //width: 1220,
                    child: ListView(
                      children: [
                        Expanded(
                            child: Container(
                          height: 50,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Spacer(),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      box.delete('email');
                                      FirebaseAuth.instance.signOut();
                                    },
                                    child: Text('izpis')),
                              ),
                            ],
                          ),
                        )),
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
