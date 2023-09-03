import 'package:accounting_app/gradniki/stroski/placaj_racun.dart';
import 'package:accounting_app/objekti/racun_strosek.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class RacunRow extends StatefulWidget {
  const RacunRow({super.key, required this.rc});
  final RacunStrosek rc;

  @override
  State<RacunRow> createState() => _RacunRowState();
}

class _RacunRowState extends State<RacunRow> {
  bool amIHovering = false;
  Offset exitFrom = Offset(0, 0);

  Color color = Colors.white;
  Color color2 = Color.fromRGBO(255, 231, 230, 1);

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
      color2 = Color.fromRGBO(255, 231, 230, 1);

      _exitCounter++;
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      color = Color.fromRGBO(217, 234, 250, 0.2);
      color2 = Color.fromRGBO(217, 234, 250, 0.2);

      x = details.position.dx;
      y = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: _incrementEnter,
        onHover: _updateLocation,
        onExit: _incrementExit,
        child: Container(
          height: 50,
          width: 1500,
          color: widget.rc.placan == true ? color : color2,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: 375,
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${DateTime.parse(widget.rc.datum).day}. ${DateTime.parse(widget.rc.datum).month}. ${DateTime.parse(widget.rc.datum).year}",
                      style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  width: 375,
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${DateTime.parse(widget.rc.rokPlacila).day}. ${DateTime.parse(widget.rc.rokPlacila).month}. ${DateTime.parse(widget.rc.rokPlacila).year}",
                      style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  width: 375,
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.rc.dobavitelj,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  width: 375,
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          double.parse(widget.rc.bilanca).toStringAsFixed(2),
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 12,
                          ),
                        ),
                        Spacer(),
                        widget.rc.placan == false
                            ? PlacajRacun(
                                rc: widget.rc,
                              )
                            : Container()
                      ],
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
