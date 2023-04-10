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

class AddBankFormMobile extends StatefulWidget {
  const AddBankFormMobile({super.key});

  @override
  State<AddBankFormMobile> createState() => _AddBankFormMobileState();
}

class _AddBankFormMobileState extends State<AddBankFormMobile> {
  final _imeController = TextEditingController();
  final _bilancaController = TextEditingController();
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  String dropdownValue = '';
  bool changed = false;
  String kontKapital = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      width: 270,
      height: 400,
      child: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30,
                    width: 255,
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
                  width: 255,
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
                    width: 255,
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
                  width: 255,
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
                    width: 255,
                    child: Text('KONT LASTNIŠKEGA KAPITALA'),
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
                  padding: EdgeInsets.all(0),
                  height: 70,
                  width: 255,
                  child: SizedBox(
                      width: 255,
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

                              List<dynamic> accountsJson = data['konti'];
                              List<Kont> accounts = [];
                              List<String> accountNames = [];
                              for (int i = 0; i < accountsJson.length; i++) {
                                Map<String, dynamic> valueMap =
                                    json.decode(accountsJson[i]);
                                Kont NewAccount = Kont.fromJson(valueMap);
                                accounts.add(NewAccount);
                              }

                              for (int j = 0; j < accounts.length; j++) {
                                String str = accounts[j].ime;
                                accountNames.add(str);
                              }
                              dropdownValue = accountNames.first;
                              if (changed == false) {
                                kontKapital = dropdownValue;
                              }
                              //debetItem = dropdownValue;

                              return Container(
                                width: 255,
                                height: 70,
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
                                          color: Colors.black,
                                          //fontSize: 8
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                    kontKapital = dropdownValue;
                                    changed = true;
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        },
                      )),
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
                      amortizacijaDate: DateTime.now().toString(),
                      debet: _bilancaController.text.toString(),
                      kredit: '0');
                  accounts.add(kon);

                  int indexkapital = accounts
                      .indexWhere((element) => element.ime == kontKapital);
                  Kont kapitalold = accounts[indexkapital];
                  accounts[indexkapital] = Kont(
                    ID: kapitalold.ID,
                    ime: kapitalold.ime,
                    tip: kapitalold.tip,
                    podtip: kapitalold.podtip,
                    bilanca: (double.parse(kapitalold.bilanca) -
                            double.parse(_bilancaController.text.toString()))
                        .toString(),
                    amortizacija: kapitalold.amortizacija,
                    bilancaDate: kapitalold.bilancaDate,
                    amortizacijaDate: kapitalold.amortizacijaDate,
                    debet: kapitalold.debet,
                    kredit: (double.parse(kapitalold.kredit) +
                            double.parse(_bilancaController.text.toString()))
                        .toString(),
                  );

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
                      transakcije: transakcije,
                      selected: false);

                  BankeiJson.add(jsonEncode(newBanka));

                  String ID = box.get('email');
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'konti': kontiJson});
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'banka': BankeiJson});
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
