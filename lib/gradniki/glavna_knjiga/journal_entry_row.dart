import 'package:accounting_app/gradniki/glavna_knjiga/journal_entry_form.dart';
import 'package:accounting_app/gradniki/glavna_knjiga/journal_entry_form_changer.dart';
import 'package:accounting_app/objekti/vnos_v_dnevnik.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class JournalEntryRow extends StatefulWidget {
  const JournalEntryRow({
    super.key,
    required this.vnos,
  });
  final VnosVDnevnik vnos;

  @override
  State<JournalEntryRow> createState() => _JournalEntryRowState();
}

class _JournalEntryRowState extends State<JournalEntryRow> {
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
                  content: JournalEntryFormChanger(
                    vnosVDnevnik: widget.vnos,
                  ),
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
            height: 90,
            color: color,
            child: Row(
              children: [
                Container(
                    width: 375,
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
                                style: TextStyle(fontFamily: 'OpenSans'),
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
                Container(
                    width: 375,
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
                                  style: TextStyle(fontFamily: 'OpenSans')),
                            )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 30,
                              child: Text('         ' + widget.vnos.kontKredit,
                                  style: TextStyle(fontFamily: 'OpenSans')),
                            )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 25,
                              child: Text(widget.vnos.komentar,
                                  style: TextStyle(fontFamily: 'OpenSans')),
                            )),
                      ],
                    )),
                Container(
                    width: 375,
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
                                  double.parse(widget.vnos.debet)
                                      .toStringAsFixed(2),
                                  style: TextStyle(fontFamily: 'OpenSans')),
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
                Container(
                  width: 375,
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
                            child: Text(
                                double.parse(widget.vnos.debet)
                                    .toStringAsFixed(2),
                                style: TextStyle(fontFamily: 'OpenSans')),
                          )),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 25,
                          )),
                    ],
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
