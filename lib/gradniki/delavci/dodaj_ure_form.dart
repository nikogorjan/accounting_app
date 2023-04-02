import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:uuid/uuid.dart';

import '../../data/data.dart';
import '../../objekti/delavec.dart';
import '../../objekti/delo.dart';
import '../../objekti/kont.dart';

class DodajUreForm extends StatefulWidget {
  const DodajUreForm({super.key});

  @override
  State<DodajUreForm> createState() => _DodajUreFormState();
}

class _DodajUreFormState extends State<DodajUreForm> {
  final _postavkaController = TextEditingController();

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  DateTime kontDate = DateTime.now();
  DateTime rokDate = DateTime.now();
  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        kontDate = value!;
      });
    });
  }

  String dropdownValue3 = '';
  bool placiloChanged = false;
  String delavec = '';
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
                    'DATUM',
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
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints.tightFor(width: 200, height: 25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color(0xEEEEEEEE),
                  ),
                  onPressed: _showDatePicker,
                  child: Center(
                    child: Text(
                      'Izberi datum',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Container(
                width: 460,
                child: Center(
                  child: Text(
                    "${kontDate.day}. ${kontDate.month}. ${kontDate.year}",
                    style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                  ),
                ),
              ),
            ],
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
                    'DELAVEC',
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
              child: SizedBox(
                  width: 340,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;

                          List<dynamic> accountsJson = data['zaposleni'];
                          List<Delavec> accounts = [];
                          List<String> accountNames = [];
                          for (int i = 0; i < accountsJson.length; i++) {
                            Map<String, dynamic> valueMap =
                                json.decode(accountsJson[i]);
                            Delavec NewAccount = Delavec.fromJson(valueMap);
                            accounts.add(NewAccount);
                          }

                          for (int j = 0; j < accounts.length; j++) {
                            String str = accounts[j].naziv;
                            accountNames.add(str);
                          }
                          dropdownValue3 = accountNames.first;
                          if (placiloChanged == false) {
                            delavec = accountNames.first;
                          }

                          //debetItem = dropdownValue;

                          return Container(
                            width: 340,
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
                              value: dropdownValue3,
                              elevation: 16,
                              style: const TextStyle(fontFamily: 'OpenSans'),
                              items: accountNames.map<DropdownMenuItem<String>>(
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
                                  dropdownValue3 = value!;
                                  placiloChanged = true;
                                });
                                delavec = dropdownValue3;
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )),
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
                    'ŠTEVILO UR',
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
                controller: _postavkaController,
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
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 150, height: 50),
            child: ElevatedButton(
              onPressed: () {
                var db = FirebaseFirestore.instance;
                String ID = box.get('email');
                final docRef = db.collection("Users").doc(ID);
                docRef.get().then((DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  List<Delavec> accounts = [];
                  List<dynamic> accountsJson = data['zaposleni'];
                  List<Delo> dela = [];
                  List<dynamic> delaJson = data['ure dela'];

                  for (int i = 0; i < accountsJson.length; i++) {
                    Map<String, dynamic> valueMap =
                        json.decode(accountsJson[i]);
                    Delavec NewAccount = Delavec.fromJson(valueMap);
                    accounts.add(NewAccount);
                  }

                  for (int i = 0; i < delaJson.length; i++) {
                    Map<String, dynamic> valueMap = json.decode(delaJson[i]);
                    Delo NewAccount = Delo.fromJson(valueMap);
                    dela.add(NewAccount);
                  }

                  //SPREMEMBE//////////////////////////////////
                  var uuid = Uuid();
                  Delo delo = Delo(
                      ID: uuid.v1(),
                      datum: kontDate.toString(),
                      stUr: _postavkaController.text.trim(),
                      delavec: delavec);
                  dela.add(delo);
                  int zaposleniindex = accounts
                      .indexWhere((element) => element.naziv == delavec);
                  Delavec old = accounts[zaposleniindex];
                  List<dynamic> u = old.ure;
                  u.add(jsonEncode(delo));
                  accounts[zaposleniindex] = Delavec(
                      ID: old.ID,
                      naziv: old.naziv,
                      naslov: old.naslov,
                      tel: old.tel,
                      email: old.email,
                      bilanca: old.bilanca,
                      urnaPostavka: old.urnaPostavka,
                      ure: u);
                  ////////////////////////////////////////////

                  List<String> kontiJson = [];
                  for (int i = 0; i < accounts.length; i++) {
                    kontiJson.add(jsonEncode(accounts[i]));
                  }

                  List<String> ureJson = [];
                  for (int i = 0; i < dela.length; i++) {
                    ureJson.add(jsonEncode(dela[i]));
                  }

                  String ID = box.get('email');
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'zaposleni': kontiJson});

                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'ure dela': ureJson});
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
