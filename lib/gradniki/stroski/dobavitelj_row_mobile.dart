import 'package:accounting_app/gradniki/prodaja/stranke_form_changer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

import '../../objekti/dobavitelj.dart';
import '../../objekti/stranka.dart';
import '../stroski/transakcije_button.dart';

class DobaviteljRowMobile extends StatefulWidget {
  const DobaviteljRowMobile({
    super.key,
    required this.dobavitelj,
  });
  final Dobavitelj dobavitelj;

  @override
  State<DobaviteljRowMobile> createState() => _DobaviteljRowMobileState();
}

class _DobaviteljRowMobileState extends State<DobaviteljRowMobile> {
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
                widget.dobavitelj.naziv,
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
                widget.dobavitelj.tel,
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
                widget.dobavitelj.email,
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
                widget.dobavitelj.naslov,
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
                widget.dobavitelj.bilanca,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
