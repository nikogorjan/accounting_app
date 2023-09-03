import 'package:accounting_app/gradniki/prodaja/placaj_racun_prodaja.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../objekti/racun_prodaja.dart';

class ProdajaRacunRow extends StatefulWidget {
  const ProdajaRacunRow({super.key, required this.rp});
  final RacunProdaja rp;

  @override
  State<ProdajaRacunRow> createState() => _ProdajaRacunRowState();
}

class _ProdajaRacunRowState extends State<ProdajaRacunRow> {
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
          color: widget.rp.placan == true ? color : color2,
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
                      "${DateTime.parse(widget.rp.datum).day}. ${DateTime.parse(widget.rp.datum).month}. ${DateTime.parse(widget.rp.datum).year}",
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
                      "${DateTime.parse(widget.rp.rokPlacila).day}. ${DateTime.parse(widget.rp.rokPlacila).month}. ${DateTime.parse(widget.rp.rokPlacila).year}",
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
                      widget.rp.stranka,
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
                          widget.rp.bilanca,
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 12,
                          ),
                        ),
                        Spacer(),
                        widget.rp.placan == false
                            ? PlacajRacunProdaja(
                                rp: widget.rp,
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
