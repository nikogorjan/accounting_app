import 'dart:convert';

import 'package:accounting_app/objekti/dobavitelj.dart';
import 'package:accounting_app/objekti/storitev.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:uuid/uuid.dart';

import '../../data/data.dart';
import '../../objekti/kont.dart';

class DodajStoritev extends StatefulWidget {
  const DodajStoritev({super.key});

  @override
  State<DodajStoritev> createState() => _DodajStoritevState();
}

class _DodajStoritevState extends State<DodajStoritev> {
  final _imeController = TextEditingController();
  final _komentarController = TextEditingController();
  final _nakupiController = TextEditingController();
  final _bilancaController = TextEditingController();

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  String ID = box.get('email');
  String dropdownValue = '';
  String changedVal = '';
  String debetItem = '';
  String kreditItem = '';
  bool changed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: 700,
      height: 500,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 320,
                    height: 30,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          'IME',
                          style: TextStyle(fontFamily: 'OpenSans'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 320,
                    height: 30,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          'DOBAVITELJ',
                          style: TextStyle(fontFamily: 'OpenSans'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 320,
                    height: 50,
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
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 320,
                    height: 50,
                    child: SizedBox(
                        width: 320,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _usersStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong");
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading");
                            }

                            return ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;

                                List<dynamic> accountsJson =
                                    data['dobavitelji'];
                                List<Dobavitelj> accounts = [];
                                List<String> accountNames = [];
                                for (int i = 0; i < accountsJson.length; i++) {
                                  Map<String, dynamic> valueMap =
                                      json.decode(accountsJson[i]);
                                  Dobavitelj NewAccount =
                                      Dobavitelj.fromJson(valueMap);
                                  accounts.add(NewAccount);
                                }

                                for (int j = 0; j < accounts.length; j++) {
                                  String str = accounts[j].naziv;
                                  accountNames.add(str);
                                }
                                dropdownValue = accountNames.first;
                                if (changed == false) {
                                  debetItem = dropdownValue;
                                }
                                //debetItem = dropdownValue;

                                return Container(
                                  width: 310,
                                  height: 50,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),

                                        //<-- SEE HERE
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.blueAccent),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.grey), //<-- SEE HERE
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                    value: dropdownValue,
                                    elevation: 16,
                                    style:
                                        const TextStyle(fontFamily: 'OpenSans'),
                                    items: accountNames
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        dropdownValue = value!;
                                      });
                                      changedVal = dropdownValue;
                                      changed = true;
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        )),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 680,
                    height: 30,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          'KOMENTAR',
                          style: TextStyle(fontFamily: 'OpenSans'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 680,
              height: 50,
              child: TextField(
                controller: _komentarController,
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 320,
                    height: 30,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          'ŠTEVILO NAKUPOV',
                          style: TextStyle(fontFamily: 'OpenSans'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 320,
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
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 320,
                    height: 50,
                    child: TextField(
                      controller: _nakupiController,
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
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 320,
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
                          hintStyle: TextStyle(
                              fontFamily: 'OpenSans', color: Colors.black)),
                    ),
                  ),
                ),
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
                List<Storitev> accounts = [];
                var db = FirebaseFirestore.instance;
                String ID = box.get('email');
                final docRef = db.collection("Users").doc(ID);
                docRef.get().then((DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  List<dynamic> accountsJson = data['storitve'];

                  for (int i = 0; i < accountsJson.length; i++) {
                    Map<String, dynamic> valueMap =
                        json.decode(accountsJson[i]);
                    Storitev NewAccount = Storitev.fromJson(valueMap);
                    accounts.add(NewAccount);
                  }

                  //SPREMEMBE//////////////////////////////////
                  var uuid = Uuid();
                  Storitev storitev = Storitev(
                      ID: uuid.v1(),
                      ime: _imeController.text.trim(),
                      dobavitelj: changedVal,
                      komentar: _komentarController.text.trim(),
                      stnakupov: _nakupiController.text.trim(),
                      bilanca: _bilancaController.text.trim());
                  accounts.add(storitev);
                  ////////////////////////////////////////////

                  List<String> kontiJson = [];
                  for (int i = 0; i < accounts.length; i++) {
                    kontiJson.add(jsonEncode(accounts[i]));
                  }

                  String ID = box.get('email');
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'storitve': kontiJson});
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
