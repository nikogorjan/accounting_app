import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../objekti/placa.dart';

class IzdajaPlacRow extends StatefulWidget {
  const IzdajaPlacRow({super.key, required this.placa});
  final Placa placa;

  @override
  State<IzdajaPlacRow> createState() => _IzdajaPlacRowState();
}

class _IzdajaPlacRowState extends State<IzdajaPlacRow> {
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
        onTap: () {},
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
                  width: 500,
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${DateTime.parse(widget.placa.datum).day}. ${DateTime.parse(widget.placa.datum).month}. ${DateTime.parse(widget.placa.datum).year}",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 500,
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.placa.delavec,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 500,
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.placa.vsota,
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
