import 'package:accounting_app/gradniki/prodaja/stranke_form_changer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

import '../../objekti/stranka.dart';
import '../stroski/transakcije_button.dart';

class StrankeRowMobile extends StatefulWidget {
  const StrankeRowMobile({super.key, required this.stranka});
  final Stranka stranka;

  @override
  State<StrankeRowMobile> createState() => _StrankeRowMobileState();
}

class _StrankeRowMobileState extends State<StrankeRowMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Naziv',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.stranka.naziv,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Telefonska številka',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.stranka.tel,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'E-naslov',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.stranka.email,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Lokacija',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.stranka.naslov,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Bilanca',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.stranka.bilanca,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
