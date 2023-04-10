import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../objekti/vnos_v_dnevnik.dart';

class JournalEntryRowMobile extends StatefulWidget {
  const JournalEntryRowMobile({super.key, required this.vnos});
  final VnosVDnevnik vnos;

  @override
  State<JournalEntryRowMobile> createState() => _JournalEntryRowMobileState();
}

class _JournalEntryRowMobileState extends State<JournalEntryRowMobile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
              //width: 375,
              child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30,
                    child: Text(
                      "${DateTime.parse(widget.vnos.datum).day}. ${DateTime.parse(widget.vnos.datum).month}. ${DateTime.parse(widget.vnos.datum).year}",
                      style: TextStyle(fontFamily: 'OpenSans', fontSize: 11),
                    ),
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30,
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 25,
                  )),
            ],
          )),
        ),
        Expanded(
          child: Container(
              //width: 375,
              child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30,
                    child: Text(widget.vnos.kontDebet,
                        style: TextStyle(fontFamily: 'OpenSans', fontSize: 11)),
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30,
                    child: Text('         ' + widget.vnos.kontKredit,
                        style: TextStyle(fontFamily: 'OpenSans', fontSize: 11)),
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 25,
                    child: Text(widget.vnos.komentar,
                        style: TextStyle(fontFamily: 'OpenSans', fontSize: 11)),
                  )),
            ],
          )),
        ),
        Expanded(
          child: Container(
              //width: 375,
              child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30,
                    child: Text(widget.vnos.debet,
                        style: TextStyle(fontFamily: 'OpenSans', fontSize: 11)),
                  )),
              Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 30,
                  )),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 25,
                  )),
            ],
          )),
        ),
        Expanded(
          child: Container(
            //width: 375,
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 30,
                    )),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 30,
                      child: Text(widget.vnos.kredit,
                          style:
                              TextStyle(fontFamily: 'OpenSans', fontSize: 11)),
                    )),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 25,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
