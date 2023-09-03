import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:uuid/uuid.dart';

import '../../data/data.dart';
import '../../objekti/stranka.dart';

class StrankaFormChanger extends StatefulWidget {
  const StrankaFormChanger({super.key, required this.stranka});
  final Stranka stranka;

  @override
  State<StrankaFormChanger> createState() => _StrankaFormChangerState();
}

class _StrankaFormChangerState extends State<StrankaFormChanger> {
  final _nazivController = TextEditingController();
  final _naslovController = TextEditingController();
  final _stevilkaController = TextEditingController();
  final _emailController = TextEditingController();
  final _bilancaController = TextEditingController();

  @override
  void initState() {
    _nazivController.text = widget.stranka.naziv;
    _naslovController.text = widget.stranka.naslov;
    _stevilkaController.text = widget.stranka.tel;
    _emailController.text = widget.stranka.email;
    _bilancaController.text = widget.stranka.bilanca;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 700,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 460,
              height: 30,
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    'NAZIV',
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 460,
              height: 50,
              child: TextField(
                controller: _nazivController,
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
                    hintStyle:
                        TextStyle(fontFamily: 'OpenSans', color: Colors.black)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 460,
              height: 30,
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    'NASLOV',
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 460,
              height: 50,
              child: TextField(
                controller: _naslovController,
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
                    hintStyle:
                        TextStyle(fontFamily: 'OpenSans', color: Colors.black)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 460,
              height: 30,
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    'TELEFONSKA ŠTEVILKA',
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 460,
              height: 50,
              child: TextField(
                controller: _stevilkaController,
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
                    hintStyle:
                        TextStyle(fontFamily: 'OpenSans', color: Colors.black)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 460,
              height: 30,
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    'E-NASLOV',
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 460,
              height: 50,
              child: TextField(
                controller: _emailController,
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
                    hintStyle:
                        TextStyle(fontFamily: 'OpenSans', color: Colors.black)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 460,
              height: 30,
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    'BILANCA',
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 460,
              height: 50,
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
                    hintStyle:
                        TextStyle(fontFamily: 'OpenSans', color: Colors.black)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 150, height: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      List<Stranka> accounts = [];
                      var db = FirebaseFirestore.instance;
                      String ID = box.get('email');
                      final docRef = db.collection("Users").doc(ID);
                      docRef.get().then((DocumentSnapshot doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        List<dynamic> accountsJson = data['stranke'];

                        for (int i = 0; i < accountsJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(accountsJson[i]);
                          Stranka NewAccount = Stranka.fromJson(valueMap);
                          accounts.add(NewAccount);
                        }

                        //SPREMEMBE//////////////////////////////////
                        int o = accounts.indexWhere(
                            (element) => element.ID == widget.stranka.ID);
                        Stranka old = accounts[o];
                        accounts.removeWhere(
                            (element) => element.ID == widget.stranka.ID);
                        var uuid = Uuid();

                        Stranka newDobavitelj = Stranka(
                            ID: old.ID,
                            naziv: _nazivController.text.trim(),
                            naslov: _naslovController.text.trim(),
                            tel: _stevilkaController.text.trim(),
                            email: _emailController.text.trim(),
                            bilanca: _bilancaController.text.trim(),
                            transakcije: old.transakcije);

                        accounts.add(newDobavitelj);
                        ////////////////////////////////////////////

                        List<String> kontiJson = [];
                        for (int i = 0; i < accounts.length; i++) {
                          kontiJson.add(jsonEncode(accounts[i]));
                        }

                        String ID = box.get('email');
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(ID)
                            .update({'stranke': kontiJson});
                      }, onError: (e) => print("Error getting document: $e"));
                    },
                    child: Text('Spremeni'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(0)),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            color: Colors.white))),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 150, height: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      List<Stranka> accounts = [];
                      var db = FirebaseFirestore.instance;
                      String ID = box.get('email');
                      final docRef = db.collection("Users").doc(ID);
                      docRef.get().then((DocumentSnapshot doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        List<dynamic> accountsJson = data['stranke'];

                        for (int i = 0; i < accountsJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(accountsJson[i]);
                          Stranka NewAccount = Stranka.fromJson(valueMap);
                          accounts.add(NewAccount);
                        }

                        //SPREMEMBE//////////////////////////////////
                        accounts.removeWhere(
                            (element) => element.ID == widget.stranka.ID);
                        ////////////////////////////////////////////

                        List<String> kontiJson = [];
                        for (int i = 0; i < accounts.length; i++) {
                          kontiJson.add(jsonEncode(accounts[i]));
                        }

                        String ID = box.get('email');
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(ID)
                            .update({'stranke': kontiJson});
                      }, onError: (e) => print("Error getting document: $e"));
                    },
                    child: Text('Odstrani'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(0)),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            color: Colors.white))),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
    ;
  }
}
