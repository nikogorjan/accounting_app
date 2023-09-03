import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'grafi/banka_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'grafi/gibanje_kapitala_graf.dart';
import 'grafi/odhodki_graf.dart';
import 'grafi/poslovni_izid_graf.dart';
import 'grafi/prodaje_graf.dart';
import 'grafi/racuni_graf.dart';

class NadzornaPloscaMobile extends StatefulWidget {
  const NadzornaPloscaMobile({super.key});

  @override
  State<NadzornaPloscaMobile> createState() => _NadzornaPloscaMobileState();
}

class _NadzornaPloscaMobileState extends State<NadzornaPloscaMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 700,
      height: MediaQuery.of(context).size.height - 80,
      child: ListView(
        children: [
          Text(
            'Armaturna plošča',
            style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 400,
            height: 400,
            color: Colors.black,
            child: BankaCarousel(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 400,
            height: 400,
            color: Color(0xEEEEEEEE).withOpacity(0.5),
            child: PoslovniIzidGraf(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 400,
            height: 400,
            color: Color(0xEEEEEEEE).withOpacity(0.5),
            child: OdhodkiGraf(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 400,
            height: 400,
            color: Color(0xEEEEEEEE).withOpacity(0.5),
            child: GibanjeKapitala(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 400,
            height: 400,
            color: Color(0xEEEEEEEE).withOpacity(0.5),
            child: ProdajeGraf(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 400,
            height: 400,
            color: Color(0xEEEEEEEE).withOpacity(0.5),
            child: RacuniGraf(),
          )
        ],
      ),
    );
  }
}
