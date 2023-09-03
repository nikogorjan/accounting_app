import 'dart:convert';

import 'package:accounting_app/gradniki/banka/delete_bank_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/banka.dart';

class BankCard extends StatefulWidget {
  const BankCard({super.key, required this.card});
  final Banka card;
  @override
  State<BankCard> createState() => _BankCardState();
}

class _BankCardState extends State<BankCard> {
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
    return GestureDetector(
      onTap: () {
        List<Banka> banke = [];
        var db = FirebaseFirestore.instance;
        String ID = box.get('email');
        final docRef = db.collection("Users").doc(ID);
        docRef.get().then((DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          List<dynamic> bankeJson = data['banka'];

          for (int i = 0; i < bankeJson.length; i++) {
            Map<String, dynamic> valueMap = json.decode(bankeJson[i]);
            Banka NewAccount = Banka.fromJson(valueMap);
            banke.add(NewAccount);
          }

          int index =
              banke.indexWhere((element) => element.ID == widget.card.ID);
          Banka old = banke[index];

          banke[index] = Banka(
              ID: old.ID,
              ime: old.ime,
              bilanca: old.bilanca,
              transakcije: old.transakcije,
              selected: true);

          for (int k = 0; k < banke.length; k++) {
            if (k == index) {
              continue;
            } else {
              banke[k] = Banka(
                  ID: banke[k].ID,
                  ime: banke[k].ime,
                  bilanca: banke[k].bilanca,
                  transakcije: banke[k].transakcije,
                  selected: false);
            }
          }

          List<String> BankeiJson = [];
          for (int i = 0; i < banke.length; i++) {
            BankeiJson.add(jsonEncode(banke[i]));
          }

          FirebaseFirestore.instance
              .collection('Users')
              .doc(ID)
              .update({'banka': BankeiJson});
        });

        global.card = widget.card.ID;
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: _incrementEnter,
        onHover: _updateLocation,
        onExit: _incrementExit,
        child: Container(
          width: 250,
          height: 125,
          decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                height: 20,
                width: 250,
                child: Row(
                  children: [
                    Spacer(),
                    DeleteBankButton(
                      banka: widget.card,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 55,
                width: 250,
                color: color,
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.card.ime,
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(217, 234, 250, 1),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      Text(
                        '€' +
                            double.parse(widget.card.bilanca)
                                .toStringAsFixed(2),
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
