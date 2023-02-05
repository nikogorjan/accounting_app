import 'package:accounting_app/gradniki/glavna_knjiga/account_form_changer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'account_form.dart';

class AccountRow extends StatefulWidget {
  const AccountRow(
      {super.key,
      required this.ID,
      required this.ime,
      required this.tip,
      required this.podtip,
      required this.bilanca,
      required this.amortizacija});
  final String ID;
  final String ime;
  final String tip;
  final String podtip;
  final String bilanca;
  final String amortizacija;

  @override
  State<AccountRow> createState() => _AccountRowState();
}

class _AccountRowState extends State<AccountRow> {
  bool amIHovering = false;
  Offset exitFrom = Offset(0, 0);

  Color color = Colors.white;
  int _enterCounter = 0;
  int _exitCounter = 0;
  double x = 0.0;
  double y = 0.0;

  void _incrementEnter(PointerEvent details) {
    setState(() {
      _enterCounter++;
    });
  }

  void _incrementExit(PointerEvent details) {
    setState(() {
      color = Colors.white;
      _exitCounter++;
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      color = Color.fromRGBO(217, 234, 250, 0.2);
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: AccountFormChanger(
                      ID: widget.ID,
                      tip: widget.tip,
                      podtip: widget.podtip,
                      bilanca: widget.bilanca,
                      amortizacija: widget.amortizacija,
                      ime: widget.ime),
                );
              });
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: _incrementEnter,
          onHover: _updateLocation,
          onExit: _incrementExit,
          child: Container(
            width: 1500,
            height: 40,
            color: color,
            child: Row(
              children: [
                Container(
                  width: 300,
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.ID,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.ime,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.tip,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.podtip,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.bilanca,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
