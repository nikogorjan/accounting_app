import 'package:accounting_app/gradniki/stroski/dobavitelj_form_changer.dart';
import 'package:accounting_app/gradniki/stroski/transakcije_button.dart';
import 'package:accounting_app/objekti/dobavitelj.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DobaviteljRow extends StatefulWidget {
  const DobaviteljRow({super.key, required this.dobavitelj});

  final Dobavitelj dobavitelj;
  @override
  State<DobaviteljRow> createState() => _DobaviteljRowState();
}

class _DobaviteljRowState extends State<DobaviteljRow> {
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
                    content:
                        DobaviteljFormChanger(dobavitelj: widget.dobavitelj));
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
                      widget.dobavitelj.naziv,
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
                      widget.dobavitelj.tel,
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
                      widget.dobavitelj.email,
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
                      widget.dobavitelj.naslov,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 260,
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.dobavitelj.bilanca,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                TransakcijeButton()
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
