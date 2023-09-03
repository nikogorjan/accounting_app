import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'grafi/banka_carousel.dart';
import 'grafi/gibanje_kapitala_graf.dart';
import 'grafi/odhodki_graf.dart';
import 'grafi/poslovni_izid_graf.dart';
import 'grafi/prodaje_graf.dart';
import 'grafi/racuni_graf.dart';

class NadzornaPloscaTablet extends StatefulWidget {
  const NadzornaPloscaTablet({super.key});

  @override
  State<NadzornaPloscaTablet> createState() => _NadzornaPloscaTabletState();
}

class _NadzornaPloscaTabletState extends State<NadzornaPloscaTablet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                'Nadzorna plošča',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 36),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Colors.black,
                        child: BankaCarousel(),
                      )
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 20,
            child: Container(
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Color(0xEEEEEEEE).withOpacity(0.5),
                        child: PoslovniIzidGraf(),
                      )
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 20,
            child: Container(
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Color(0xEEEEEEEE).withOpacity(0.5),
                        child: OdhodkiGraf(),
                      )
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 20,
            child: Container(
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Color(0xEEEEEEEE).withOpacity(0.5),
                        child: GibanjeKapitala(),
                      )
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 20,
            child: Container(
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Color(0xEEEEEEEE).withOpacity(0.5),
                        child: ProdajeGraf(),
                      )
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 20,
            child: Container(
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Color(0xEEEEEEEE).withOpacity(0.5),
                        child: RacuniGraf(),
                      )
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
