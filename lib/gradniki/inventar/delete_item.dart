import 'dart:convert';

import 'package:accounting_app/objekti/predmet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

import '../../data/data.dart';
import '../../objekti/banka.dart';
import '../../objekti/kont.dart';

class DeleteItem extends StatefulWidget {
  const DeleteItem({super.key, required this.predmet});
  final Predmet predmet;
  @override
  State<DeleteItem> createState() => _DeleteItemState();
}

class _DeleteItemState extends State<DeleteItem> {
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
      color = Colors.red;
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        List<Kont> accounts = [];
        List<Predmet> banke = [];
        var db = FirebaseFirestore.instance;
        String ID = box.get('email');
        final docRef = db.collection("Users").doc(ID);
        docRef.get().then((DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          List<dynamic> accountsJson = data['konti'];
          List<dynamic> banksjson = data['predmeti'];

          for (int i = 0; i < accountsJson.length; i++) {
            Map<String, dynamic> valueMap = json.decode(accountsJson[i]);
            Kont NewAccount = Kont.fromJson(valueMap);
            accounts.add(NewAccount);
          }

          for (int j = 0; j < banksjson.length; j++) {
            Map<String, dynamic> valueMap = json.decode(banksjson[j]);
            Predmet newEntry = Predmet.fromJson(valueMap);
            banke.add(newEntry);
          }

          //accounts.removeWhere((element) => element.ime == widget.banka.ime);
          banke.removeWhere((element) => element.ID == widget.predmet.ID);

          List<String> bankeJson = [];
          for (int k = 0; k < banke.length; k++) {
            bankeJson.add(jsonEncode(banke[k]));
          }

          List<String> kontiJson = [];
          for (int i = 0; i < accounts.length; i++) {
            kontiJson.add(jsonEncode(accounts[i]));
          }

          String ID = box.get('email');
          /*FirebaseFirestore.instance
              .collection('Users')
              .doc(ID)
              .update({'konti': kontiJson});*/

          FirebaseFirestore.instance
              .collection('Users')
              .doc(ID)
              .update({'predmeti': bankeJson});
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: _incrementEnter,
        onHover: _updateLocation,
        onExit: _incrementExit,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: ImageIcon(
            AssetImage('lib/sredstva/remove.png'),
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
