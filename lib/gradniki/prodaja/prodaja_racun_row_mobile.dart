import 'package:accounting_app/gradniki/prodaja/placaj_racun_prodaja.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../objekti/racun_prodaja.dart';

class ProdajaRacunRowMobile extends StatefulWidget {
  const ProdajaRacunRowMobile({super.key, required this.rp});
  final RacunProdaja rp;
  @override
  State<ProdajaRacunRowMobile> createState() => _ProdajaRacunRowMobileState();
}

class _ProdajaRacunRowMobileState extends State<ProdajaRacunRowMobile> {
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
      child: Container(
        color: widget.rp.placan == true ? color : color2,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Datum',
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                ),
                Spacer(),
                Text(
                  "${DateTime.parse(widget.rp.datum).day}. ${DateTime.parse(widget.rp.datum).month}. ${DateTime.parse(widget.rp.datum).year}",
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Rok plačila',
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                ),
                Spacer(),
                Text(
                  "${DateTime.parse(widget.rp.rokPlacila).day}. ${DateTime.parse(widget.rp.rokPlacila).month}. ${DateTime.parse(widget.rp.rokPlacila).year}",
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Stranka',
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                ),
                Spacer(),
                Text(
                  widget.rp.stranka,
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Vsota',
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                ),
                Spacer(),
                Text(
                  widget.rp.bilanca,
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                ),
              ],
            ),
            widget.rp.placan == false
                ? PlacajRacunProdaja(
                    rp: widget.rp,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
