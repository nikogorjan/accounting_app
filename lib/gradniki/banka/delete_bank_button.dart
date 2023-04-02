import 'package:accounting_app/objekti/banka.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:convert';
//import 'dart:ffi';

import 'package:accounting_app/objekti/kont.dart';
import 'package:accounting_app/objekti/vnos_v_dnevnik.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/data.dart';

class DeleteBankButton extends StatefulWidget {
  const DeleteBankButton({super.key, required this.banka});
  final Banka banka;

  @override
  State<DeleteBankButton> createState() => _DeleteBankButtonState();
}

class _DeleteBankButtonState extends State<DeleteBankButton> {
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
        List<Banka> banke = [];
        var db = FirebaseFirestore.instance;
        String ID = box.get('email');
        final docRef = db.collection("Users").doc(ID);
        docRef.get().then((DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          List<dynamic> accountsJson = data['konti'];
          List<dynamic> banksjson = data['banka'];

          for (int i = 0; i < accountsJson.length; i++) {
            Map<String, dynamic> valueMap = json.decode(accountsJson[i]);
            Kont NewAccount = Kont.fromJson(valueMap);
            accounts.add(NewAccount);
          }

          for (int j = 0; j < banksjson.length; j++) {
            Map<String, dynamic> valueMap = json.decode(banksjson[j]);
            Banka newEntry = Banka.fromJson(valueMap);
            banke.add(newEntry);
          }

          accounts.removeWhere((element) => element.ime == widget.banka.ime);
          banke.removeWhere((element) => element.ID == widget.banka.ID);

          List<String> bankeJson = [];
          for (int k = 0; k < banke.length; k++) {
            bankeJson.add(jsonEncode(banke[k]));
          }

          List<String> kontiJson = [];
          for (int i = 0; i < accounts.length; i++) {
            kontiJson.add(jsonEncode(accounts[i]));
          }

          String ID = box.get('email');
          FirebaseFirestore.instance
              .collection('Users')
              .doc(ID)
              .update({'konti': kontiJson});

          FirebaseFirestore.instance
              .collection('Users')
              .doc(ID)
              .update({'banka': bankeJson});
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: _incrementEnter,
        onHover: _updateLocation,
        onExit: _incrementExit,
        child: Container(
          width: 10,
          height: 10,
          color: color,
          child: ImageIcon(
            AssetImage('lib/sredstva/remove.png'),
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
