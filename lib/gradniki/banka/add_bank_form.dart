import 'dart:convert';

import 'package:accounting_app/objekti/banka.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:accounting_app/objekti/kont.dart';
import 'package:accounting_app/objekti/vnos_v_dnevnik.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/data.dart';
import '../../objekti/transakcija.dart';

class AddBankForm extends StatefulWidget {
  const AddBankForm({super.key});

  @override
  State<AddBankForm> createState() => _AddBankFormState();
}

class _AddBankFormState extends State<AddBankForm> {
  final _imeController = TextEditingController();
  final _bilancaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: 600,
      height: 300,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30,
                    width: 560,
                    child: Text('IME'),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 560,
                  child: TextField(
                    controller: _imeController,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),

                          //<-- SEE HERE
                          borderSide:
                              BorderSide(width: 1, color: Colors.blueAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.grey), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(0),
                        ),
                        hintText: '',
                        hintStyle: TextStyle(
                            fontFamily: 'OpenSans', color: Colors.black)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30,
                    width: 560,
                    child: Text('BILANCA'),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 560,
                  child: TextField(
                    controller: _bilancaController,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),

                          //<-- SEE HERE
                          borderSide:
                              BorderSide(width: 1, color: Colors.blueAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.grey), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(0),
                        ),
                        hintText: '',
                        hintStyle: TextStyle(
                            fontFamily: 'OpenSans', color: Colors.black)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 150, height: 50),
            child: ElevatedButton(
              onPressed: () {
                List<Banka> banke = [];
                List<Kont> accounts = [];
                var db = FirebaseFirestore.instance;
                String ID = box.get('email');
                final docRef = db.collection("Users").doc(ID);
                docRef.get().then((DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  List<dynamic> bankeJson = data['banka'];
                  List<dynamic> accountsJson = data['konti'];
                  for (int i = 0; i < accountsJson.length; i++) {
                    Map<String, dynamic> valueMap =
                        json.decode(accountsJson[i]);
                    Kont NewAccount = Kont.fromJson(valueMap);
                    accounts.add(NewAccount);
                  }
                  Kont kon = Kont(
                      ID: '',
                      ime: _imeController.text.toString(),
                      tip: 'Gibljiva sredstva',
                      podtip: 'Denarna sredstva',
                      bilanca: _bilancaController.text.toString(),
                      amortizacija: '',
                      bilancaDate: DateTime.now().toString(),
                      amortizacijaDate: DateTime.now().toString());
                  accounts.add(kon);

                  List<String> kontiJson = [];
                  for (int i = 0; i < accounts.length; i++) {
                    kontiJson.add(jsonEncode(accounts[i]));
                  }

                  for (int i = 0; i < bankeJson.length; i++) {
                    Map<String, dynamic> valueMap = json.decode(bankeJson[i]);
                    Banka NewAccount = Banka.fromJson(valueMap);
                    banke.add(NewAccount);
                  }

                  List<String> BankeiJson = [];
                  for (int i = 0; i < banke.length; i++) {
                    BankeiJson.add(jsonEncode(banke[i]));
                  }
                  var uuid = Uuid();
                  List<String> transakcije = [];
                  Banka newBanka = Banka(
                      ID: uuid.v1(),
                      ime: _imeController.text.toString(),
                      bilanca: _bilancaController.text.toString(),
                      transakcije: transakcije);

                  BankeiJson.add(jsonEncode(newBanka));

                  String ID = box.get('email');
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'konti': kontiJson});
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'banke': BankeiJson});
                }, onError: (e) => print("Error getting document: $e"));
              },
              child: Text('Dodaj'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                  textStyle: MaterialStateProperty.all(const TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                      color: Colors.white))),
            ),
          )
        ],
      ),
    );
  }
}
