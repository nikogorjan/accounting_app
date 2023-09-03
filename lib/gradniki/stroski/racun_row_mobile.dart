import 'package:accounting_app/gradniki/stroski/placaj_racun.dart';
import 'package:accounting_app/objekti/racun_strosek.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class RacunRowMobile extends StatefulWidget {
  const RacunRowMobile({super.key, required this.rc});
  final RacunStrosek rc;

  @override
  State<RacunRowMobile> createState() => _RacunRowMobileState();
}

class _RacunRowMobileState extends State<RacunRowMobile> {
  Color color = Colors.white;
  Color color2 = Color.fromRGBO(255, 231, 230, 1);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: widget.rc.placan == true ? color : color2,
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
                  "${DateTime.parse(widget.rc.datum).day}. ${DateTime.parse(widget.rc.datum).month}. ${DateTime.parse(widget.rc.datum).year}",
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
                  "${DateTime.parse(widget.rc.rokPlacila).day}. ${DateTime.parse(widget.rc.rokPlacila).month}. ${DateTime.parse(widget.rc.rokPlacila).year}",
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
                  widget.rc.dobavitelj,
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
                  widget.rc.bilanca,
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                ),
              ],
            ),
            widget.rc.placan == false
                ? PlacajRacun(
                    rc: widget.rc,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
