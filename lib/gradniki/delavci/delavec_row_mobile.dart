import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../objekti/delavec.dart';
import 'package:accounting_app/gradniki/prodaja/stranke_form_changer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

import '../../objekti/stranka.dart';
import '../stroski/transakcije_button.dart';
import 'delavec_form_changer.dart';

class DelavecRowMobile extends StatefulWidget {
  const DelavecRowMobile({super.key, required this.delavec});
  final Delavec delavec;

  @override
  State<DelavecRowMobile> createState() => _DelavecRowMobileState();
}

class _DelavecRowMobileState extends State<DelavecRowMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Ime',
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              ),
              Spacer(),
              Text(
                widget.delavec.naziv,
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Naslov',
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              ),
              Spacer(),
              Text(
                widget.delavec.naslov,
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Telefonska številka',
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              ),
              Spacer(),
              Text(
                widget.delavec.tel,
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'E-naslov',
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              ),
              Spacer(),
              Text(
                widget.delavec.email,
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Urna postavka',
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              ),
              Spacer(),
              Text(
                widget.delavec.urnaPostavka,
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Bilanca',
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              ),
              Spacer(),
              Text(
                widget.delavec.bilanca,
                style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
