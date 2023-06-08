import 'dart:typed_data';

import 'package:accounting_app/data/data.dart';
import 'package:accounting_app/gradniki/inventar/delete_item.dart';
import 'package:accounting_app/objekti/predmet.dart';
import 'package:accounting_app/services/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ItemRow extends StatefulWidget {
  const ItemRow({super.key, required this.predmet});
  final Predmet predmet;

  @override
  State<ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
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

  Storage storage = Storage();
  late String image;
  late String data;
  late String ID;
  late String path;

  @override
  void initState() {
    ID = box.get('email');
    path = box.get('email') + '/images/' + widget.predmet.ime + '.png';
    super.initState();
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
                  content: Container(
                    height: 500,
                    width: 500,
                  ),
                );
              });
        },
        child: Container(
          width: 1500,
          height: 150,
          color: color,
          child: Row(
            children: [
              Container(
                width: 375,
                height: 150,
                child: Row(
                  children: [
                    FutureBuilder(
                      future: storage.getData(
                          'users',
                          box.get('email') +
                              '/images/' +
                              widget.predmet.ime +
                              '.png'),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text(
                            "Something went wrong",
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            width: 140,
                            height: 140,
                            child: Image.network(
                              snapshot.data.toString(),
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.predmet.ime,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 375,
                height: 150,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        widget.predmet.kolicina,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                        ),
                      ),
                      if (widget.predmet.enota != '/')
                        Text(' ' + widget.predmet.enota)
                    ],
                  ),
                ),
              ),
              Container(
                width: 375,
                height: 150,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.predmet.tip,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    //color: Colors.blue,
                    width: 335,
                    height: 150,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        double.parse(widget.predmet.bilanca).toStringAsFixed(2),
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  //Spacer(),
                  DeleteItem(
                    predmet: widget.predmet,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
