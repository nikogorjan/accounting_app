import 'dart:convert';

import 'package:accounting_app/objekti/predmet.dart';
import 'package:accounting_app/objekti/produkt_storitev.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:uuid/uuid.dart';

import '../../data/data.dart';

class ProduktForm extends StatefulWidget {
  const ProduktForm({super.key});

  @override
  State<ProduktForm> createState() => _ProduktFormState();
}

class _ProduktFormState extends State<ProduktForm> {
  final _cenaController = TextEditingController();
  final _prodajaController = TextEditingController();
  final _bilancaController = TextEditingController();
  final _emailController = TextEditingController();

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  String ID = box.get('email');
  String dropdownValue = '';
  bool changed = false;
  String produkt = '';
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
                    'PRODUKT',
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
                  width: 460,
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
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;

                          List<dynamic> accountsJson = data['predmeti'];
                          List<Predmet> accounts = [];
                          List<String> accountNames = [];
                          for (int i = 0; i < accountsJson.length; i++) {
                            Map<String, dynamic> valueMap =
                                json.decode(accountsJson[i]);
                            Predmet NewAccount = Predmet.fromJson(valueMap);
                            accounts.add(NewAccount);
                          }

                          for (int j = 0; j < accounts.length; j++) {
                            String str = accounts[j].ime;
                            accountNames.add(str);
                          }
                          dropdownValue = accountNames.first;
                          if (changed == false) {
                            produkt = dropdownValue;
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
                                  dropdownValue = value!;
                                });
                                produkt = dropdownValue;
                                changed = true;
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
                    'CENA',
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
                controller: _cenaController,
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
                    'ŠTEVILO PRODAJ',
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
                controller: _prodajaController,
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
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 150, height: 50),
            child: ElevatedButton(
              onPressed: () {
                List<ProduktStoritev> accounts = [];
                var db = FirebaseFirestore.instance;
                String ID = box.get('email');
                final docRef = db.collection("Users").doc(ID);
                docRef.get().then((DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  List<dynamic> accountsJson = data['produkti in storitve'];

                  for (int i = 0; i < accountsJson.length; i++) {
                    Map<String, dynamic> valueMap =
                        json.decode(accountsJson[i]);
                    ProduktStoritev NewAccount =
                        ProduktStoritev.fromJson(valueMap);
                    accounts.add(NewAccount);
                  }

                  //SPREMEMBE//////////////////////////////////
                  var uuid = Uuid();

                  ProduktStoritev newProduct = ProduktStoritev(
                      ID: uuid.v1(),
                      PS: 'produkt',
                      naziv: produkt,
                      cena: _cenaController.text.trim(),
                      prodaja: _prodajaController.text.trim(),
                      bilanca: _bilancaController.text.trim());

                  accounts.add(newProduct);
                  ////////////////////////////////////////////

                  List<String> kontiJson = [];
                  for (int i = 0; i < accounts.length; i++) {
                    kontiJson.add(jsonEncode(accounts[i]));
                  }

                  String ID = box.get('email');
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'produkti in storitve': kontiJson});
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
