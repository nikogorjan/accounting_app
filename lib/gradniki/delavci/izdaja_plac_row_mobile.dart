import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../objekti/delavec.dart';
import 'package:accounting_app/gradniki/prodaja/stranke_form_changer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

import '../../objekti/delo.dart';
import '../../objekti/placa.dart';
import '../../objekti/stranka.dart';
import '../stroski/transakcije_button.dart';
import 'delavec_form_changer.dart';

class IzdajaPlacRowMobile extends StatefulWidget {
  const IzdajaPlacRowMobile({super.key, required this.placa});
  final Placa placa;

  @override
  State<IzdajaPlacRowMobile> createState() => _IzdajaPlacRowMobileState();
}

class _IzdajaPlacRowMobileState extends State<IzdajaPlacRowMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: [
          Expanded(
              child: Container(
            child: Text(
              "${DateTime.parse(widget.placa.datum).day}. ${DateTime.parse(widget.placa.datum).month}. ${DateTime.parse(widget.placa.datum).year}",
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
            ),
          )),
          Expanded(
              child: Container(
            child: Text(
              widget.placa.delavec,
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
            ),
          )),
          Expanded(
              child: Container(
            child: Text(
              widget.placa.vsota,
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
            ),
          ))
        ],
      ),
    );
  }
}
