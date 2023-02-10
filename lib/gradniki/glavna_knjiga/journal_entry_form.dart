import 'dart:convert';
//import 'dart:ffi';

import 'package:accounting_app/objekti/kont.dart';
import 'package:accounting_app/objekti/vnos_v_dnevnik.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:uuid/uuid.dart';

import '../../data/data.dart';

class JournalEntryForm extends StatefulWidget {
  const JournalEntryForm({super.key});

  @override
  State<JournalEntryForm> createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  final _bilancaController = TextEditingController();
  final _komentarController = TextEditingController();
  String debetItem = '';
  String kreditItem = '';
  bool changed = false;
  bool changed2 = false;

  String dropdownValue = '';
  String dropdownValue2 = '';
  List<String> imenaKontov = [];
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  String ID = box.get('email');

  Future<List<String>> getAccountNames() async {
    List<Kont> accounts = [];
    List<String> accountNames = [];
    String ID = box.get('email');
    final docRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(ID)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      List<dynamic> accountsJson = data['konti'];

      for (int i = 0; i < accountsJson.length; i++) {
        Map<String, dynamic> valueMap = json.decode(accountsJson[i]);
        Kont NewAccount = Kont.fromJson(valueMap);
        accounts.add(NewAccount);
      }

      for (int j = 0; j < accounts.length; j++) {
        String str = accounts[j].ime;
        accountNames.add(str);
      }
    }, onError: (e) => print("Error getting document: $e"));

    return accountNames;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      height: 500,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 310,
                    height: 30,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          'DEBET',
                          style: TextStyle(fontFamily: 'OpenSans'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 310,
                    height: 30,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          'KREDIT',
                          style: TextStyle(fontFamily: 'OpenSans'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 310,
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
                    width: 310,
                    height: 50,
                    color: Colors.white,
                    child: SizedBox(
                        width: 310,
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
                                      debetItem = dropdownValue;
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
                  width: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 310,
                    height: 50,
                    color: Colors.white,
                    child: SizedBox(
                        width: 310,
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
                                dropdownValue2 = accountNames.last;
                                if (changed2 == false) {
                                  kreditItem = dropdownValue2;
                                }
                                //kreditItem = dropdownValue2;

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
                                    value: dropdownValue2,
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
                                        dropdownValue2 = value!;
                                      });
                                      kreditItem = dropdownValue2;
                                      changed2 = true;
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
                  width: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 310,
                    height: 50,
                    color: Colors.white,
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
            height: 10,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 30,
              width: 960,
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: 960,
              height: 50,
              color: Colors.white,
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
            height: 30,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 150, height: 50),
            child: ElevatedButton(
              onPressed: () {
                List<Kont> accounts = [];
                List<VnosVDnevnik> vnosiVDnevnik = [];
                var db = FirebaseFirestore.instance;
                String ID = box.get('email');
                final docRef = db.collection("Users").doc(ID);
                docRef.get().then((DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  List<dynamic> accountsJson = data['konti'];
                  List<dynamic> vnosiJson = data['vnosi v dnevnik'];

                  for (int i = 0; i < accountsJson.length; i++) {
                    Map<String, dynamic> valueMap =
                        json.decode(accountsJson[i]);
                    Kont NewAccount = Kont.fromJson(valueMap);
                    accounts.add(NewAccount);
                  }

                  for (int j = 0; j < vnosiJson.length; j++) {
                    Map<String, dynamic> valueMap = json.decode(vnosiJson[j]);
                    VnosVDnevnik newEntry = VnosVDnevnik.fromJson(valueMap);
                    vnosiVDnevnik.add(newEntry);
                  }

                  //SPREMEMBE//////////////////////////////////
                  int d = accounts
                      .indexWhere((element) => element.ime == debetItem);
                  Kont debet = accounts[d];
                  int k = accounts
                      .indexWhere((element) => element.ime == kreditItem);
                  Kont kredit = accounts[k];
                  accounts.removeWhere((element) => element.ime == debetItem);
                  accounts.removeWhere((element) => element.ime == kreditItem);

                  String debetBilanca = debet.bilanca;
                  String kreditBilanca = kredit.bilanca;
                  var debetDouble = double.parse(debetBilanca);
                  var kreditDouble = double.parse(kreditBilanca);
                  var bilancaDouble =
                      double.parse(_bilancaController.text.trim());
                  var novaBilancaDebet = debetDouble + bilancaDouble;
                  var novaBilancaKredit = kreditDouble - bilancaDouble;

                  Kont newDebet = Kont(
                      ID: debet.ID,
                      ime: debet.ime,
                      tip: debet.tip,
                      podtip: debet.podtip,
                      bilanca: novaBilancaDebet.toString(),
                      amortizacija: debet.amortizacija,
                      bilancaDate: debet.bilancaDate,
                      amortizacijaDate: debet.amortizacijaDate);
                  Kont newKredit = Kont(
                      ID: kredit.ID,
                      ime: kredit.ime,
                      tip: kredit.tip,
                      podtip: kredit.podtip,
                      bilanca: novaBilancaKredit.toString(),
                      amortizacija: kredit.amortizacija,
                      bilancaDate: kredit.bilancaDate,
                      amortizacijaDate: kredit.amortizacijaDate);

                  accounts.add(newDebet);
                  accounts.add(newKredit);
                  var uuid = Uuid();

                  VnosVDnevnik novVnos = VnosVDnevnik(
                      datum: DateTime.now().toString(),
                      debet: _bilancaController.text.trim(),
                      kredit: _bilancaController.text.trim(),
                      kontDebet: debetItem,
                      kontKredit: kreditItem,
                      komentar: _komentarController.text.toString(),
                      id: uuid.v1());
                  ////////////////////////////////////////////

                  vnosiVDnevnik.add(novVnos);
                  List<String> vnosiJsoNew = [];
                  for (int k = 0; k < vnosiVDnevnik.length; k++) {
                    vnosiJsoNew.add(jsonEncode(vnosiVDnevnik[k]));
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
                      .update({'vnosi v dnevnik': vnosiJsoNew});
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
