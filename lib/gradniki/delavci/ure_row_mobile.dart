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
import '../../objekti/stranka.dart';
import '../stroski/transakcije_button.dart';
import 'delavec_form_changer.dart';

class UreRowMobile extends StatefulWidget {
  const UreRowMobile({super.key, required this.delo});
  final Delo delo;
  @override
  State<UreRowMobile> createState() => _UreRowMobileState();
}

class _UreRowMobileState extends State<UreRowMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: [
          Expanded(
              child: Container(
            child: Text(
              "${DateTime.parse(widget.delo.datum).day}. ${DateTime.parse(widget.delo.datum).month}. ${DateTime.parse(widget.delo.datum).year}",
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
            ),
          )),
          Expanded(
              child: Container(
            child: Text(
              widget.delo.delavec,
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
            ),
          )),
          Expanded(
              child: Container(
            child: Text(
              widget.delo.stUr,
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
            ),
          ))
        ],
      ),
    );
  }
}
