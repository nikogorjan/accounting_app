import 'dart:convert';

import 'package:accounting_app/objekti/vnos_v_dnevnik.dart';
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
import '../../objekti/placa.dart';

class DodajPlacoForm extends StatefulWidget {
  const DodajPlacoForm({super.key});

  @override
  State<DodajPlacoForm> createState() => _DodajPlacoFormState();
}

bool isDateInRange(DateTime date, DateTime startDate, DateTime endDate) {
  return date.isAfter(startDate.subtract(Duration(days: 1))) &&
      date.isBefore(endDate.add(Duration(days: 1)));
}

class _DodajPlacoFormState extends State<DodajPlacoForm> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  DateTime dateStart = DateTime.now();
  DateTime dateEnd = DateTime.now();
  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        dateStart = value!;
      });
    });
  }

  void _showDatePicker2() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        dateEnd = value!;
      });
    });
  }

  String dropdownValue3 = '';
  bool placiloChanged = false;
  String delavec = '';

  String dropdownValue2 = '';
  bool kontChanged = false;
  String kont = '';

  String dropdownValue1 = '';
  bool kontChanged1 = false;
  String kont1 = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 700,
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
                    'KONT IZDAJE PLAČILA',
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
                          dropdownValue1 = accountNames.first;
                          if (kontChanged1 == false) {
                            kont1 = accountNames.first;
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
                              value: dropdownValue1,
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
                                  dropdownValue1 = value!;
                                  kontChanged1 = true;
                                });
                                kont1 = dropdownValue1;
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )),
            ),
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
                    'KONT ZAPISA PLAČ',
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
                          dropdownValue2 = accountNames.first;
                          if (kontChanged == false) {
                            kont = accountNames.first;
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
                              value: dropdownValue2,
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
                                  dropdownValue2 = value!;
                                  kontChanged = true;
                                });
                                kont = dropdownValue2;
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )),
            ),
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
                    'ZAČETNI DATUM',
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
                    "${dateStart.day}. ${dateStart.month}. ${dateStart.year}",
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
                    'KONČNI DATUM',
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
                  onPressed: _showDatePicker2,
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
                    "${dateEnd.day}. ${dateEnd.month}. ${dateEnd.year}",
                    style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                  ),
                ),
              ),
            ],
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
                  List<Kont> konti = [];
                  List<dynamic> kontiJson = data['konti'];
                  List<VnosVDnevnik> vnosi = [];
                  List<dynamic> jsonvnosi = data['vnosi v dnevnik'];
                  List<Placa> place = [];
                  List<dynamic> jsonplace = data['place'];

                  for (int i = 0; i < accountsJson.length; i++) {
                    Map<String, dynamic> valueMap =
                        json.decode(accountsJson[i]);
                    Delavec NewAccount = Delavec.fromJson(valueMap);
                    accounts.add(NewAccount);
                  }

                  for (int i = 0; i < jsonplace.length; i++) {
                    Map<String, dynamic> valueMap = json.decode(jsonplace[i]);
                    Placa NewAccount = Placa.fromJson(valueMap);
                    place.add(NewAccount);
                  }

                  for (int i = 0; i < jsonvnosi.length; i++) {
                    Map<String, dynamic> valueMap = json.decode(jsonvnosi[i]);
                    VnosVDnevnik NewAccount = VnosVDnevnik.fromJson(valueMap);
                    vnosi.add(NewAccount);
                  }

                  for (int i = 0; i < delaJson.length; i++) {
                    Map<String, dynamic> valueMap = json.decode(delaJson[i]);
                    Delo NewAccount = Delo.fromJson(valueMap);
                    dela.add(NewAccount);
                  }

                  for (int i = 0; i < kontiJson.length; i++) {
                    Map<String, dynamic> valueMap = json.decode(kontiJson[i]);
                    Kont NewAccount = Kont.fromJson(valueMap);
                    konti.add(NewAccount);
                  }

                  //SPREMEMBE//////////////////////////////////
                  int delavecIndex = accounts
                      .indexWhere((element) => element.naziv == delavec);
                  Delavec delavecc = accounts[delavecIndex];
                  List<dynamic> ureDela = accounts[delavecIndex].ure;
                  List<Delo> ure = [];
                  for (int i = 0; i < ureDela.length; i++) {
                    Map<String, dynamic> valueMap = json.decode(ureDela[i]);
                    Delo delo = Delo.fromJson(valueMap);
                    ure.add(delo);
                  }

                  List<Delo> ureCas = [];
                  for (int i = 0; i < ure.length; i++) {
                    if (isDateInRange(
                        DateTime.parse(ure[i].datum), dateStart, dateEnd)) {
                      ureCas.add(ure[i]);
                    }
                  }

                  double placa = 0;
                  for (int i = 0; i < ureCas.length; i++) {
                    placa += double.parse(ureCas[i].stUr) *
                        double.parse(delavecc.urnaPostavka);
                  }
                  var uuid = Uuid();

                  Placa novaPlaca = Placa(
                      ID: uuid.v1(),
                      delavec: delavec,
                      vsota: placa.toString(),
                      datum: DateTime.now().toString());

                  int indexdebet =
                      konti.indexWhere((element) => element.ime == kont);
                  int indexkredit =
                      konti.indexWhere((element) => element.ime == kont1);
                  Kont debetOld = konti[indexdebet];
                  Kont kreditOld = konti[indexkredit];
                  konti[indexdebet] = Kont(
                      ID: debetOld.ID,
                      ime: debetOld.ime,
                      tip: debetOld.tip,
                      podtip: debetOld.podtip,
                      bilanca:
                          (double.parse(debetOld.bilanca) + placa).toString(),
                      amortizacija: debetOld.amortizacija,
                      bilancaDate: debetOld.bilancaDate,
                      amortizacijaDate: debetOld.amortizacijaDate,
                      debet: (double.parse(debetOld.debet) + placa).toString(),
                      kredit: debetOld.kredit);

                  konti[indexkredit] = Kont(
                    ID: kreditOld.ID,
                    ime: kreditOld.ime,
                    tip: kreditOld.tip,
                    podtip: kreditOld.podtip,
                    bilanca:
                        (double.parse(kreditOld.bilanca) - placa).toString(),
                    amortizacija: kreditOld.amortizacija,
                    bilancaDate: kreditOld.bilancaDate,
                    amortizacijaDate: kreditOld.amortizacijaDate,
                    debet: kreditOld.debet,
                    kredit: (double.parse(kreditOld.kredit) + placa).toString(),
                  );

                  VnosVDnevnik novnvos = VnosVDnevnik(
                      datum: DateTime.now().toString(),
                      debet: placa.toString(),
                      kredit: placa.toString(),
                      kontDebet: debetOld.ime,
                      kontKredit: kreditOld.ime,
                      komentar: '',
                      id: uuid.v1());

                  vnosi.add(novnvos);

                  int delavecIndexx = accounts
                      .indexWhere((element) => element.naziv == delavec);

                  Delavec oldDelavec = accounts[delavecIndexx];
                  accounts[delavecIndexx] = Delavec(
                      ID: oldDelavec.ID,
                      naziv: oldDelavec.naziv,
                      naslov: oldDelavec.naslov,
                      tel: oldDelavec.tel,
                      email: oldDelavec.email,
                      bilanca:
                          (double.parse(oldDelavec.bilanca) + placa).toString(),
                      urnaPostavka: oldDelavec.urnaPostavka,
                      ure: oldDelavec.ure);

                  Placa novaPlacaa = Placa(
                      ID: uuid.v1(),
                      delavec: delavec,
                      vsota: placa.toString(),
                      datum: DateTime.now().toString());

                  jsonplace.add(jsonEncode(novaPlacaa));

                  List<String> kontijjson = [];
                  for (int i = 0; i < konti.length; i++) {
                    kontijjson.add(jsonEncode(konti[i]));
                  }

                  List<String> delavcijjson = [];
                  for (int i = 0; i < accounts.length; i++) {
                    delavcijjson.add(jsonEncode(accounts[i]));
                  }

                  List<String> vnosijjson = [];
                  for (int i = 0; i < vnosi.length; i++) {
                    vnosijjson.add(jsonEncode(vnosi[i]));
                  }

                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'place': jsonplace});

                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'vnosi v dnevnik': vnosijjson});

                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'konti': kontijjson});

                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'zaposleni': delavcijjson});

                  ////////////////////////////////////////////

                  /*List<String> kontiJson = [];
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
                      .update({'zaposleni': kontiJson});*/
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
