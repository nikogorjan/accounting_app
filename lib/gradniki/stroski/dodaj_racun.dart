import 'dart:convert';

import 'package:accounting_app/gradniki/stroski/vnos_v_racun.dart';
import 'package:accounting_app/objekti/dobavitelj.dart';
import 'package:accounting_app/objekti/predmet.dart';
import 'package:accounting_app/objekti/racun_strosek.dart';
import 'package:accounting_app/objekti/storitev.dart';
import 'package:accounting_app/objekti/transakcija.dart';
import 'package:accounting_app/objekti/vnos_v_dnevnik.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/data.dart';
import '../../objekti/banka.dart';
import '../../objekti/kont.dart';
import '../../objekti/strosek.dart';

class DodajRacun extends StatefulWidget {
  const DodajRacun({super.key});

  @override
  State<DodajRacun> createState() => _DodajRacunState();
}

class _DodajRacunState extends State<DodajRacun> {
  String _childText = '';
  String? _dropdownValue;
  List<VnosVRacun> _children = [];
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  final Stream<QuerySnapshot> _usersStream2 = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  /*void _onTextChanged(String value) {
    setState(() {
      _childText = value;
    });
  }

  void _onDropdownChanged(String? value) {
    setState(() {
      _dropdownValue = value;
    });
  }*/
  void _onChildTextChanged(int index, String value) {
    // Do something with the value from the child's text field
    /*stroski[index].kolicina = value;
    print('Child $index text changed: $value');*/
  }

  double oldVal = 0;
  void _onChildTextChanged2(int index, String value) {
    // Do something with the value from the child's text field
    /* stroski[index].cena = value;
    double skupnaVrednostt = 0.0;

    setState(() {
      for (int i = 0; i < stroski.length; i++) {
        skupnaVrednostt = skupnaVrednostt + double.parse(stroski[i].cena);
        skupnaVrednost = skupnaVrednostt.toString();
      }
    });

    print('Child $index text changed2: $value');*/
  }

  void _onChildDropdownChanged(int index, String? value) {
    // Do something with the value from the child's dropdown button
    /*stroski[index].IS = value;

    print('Child $index dropdown value changed: $value');*/
  }

  void _onChildDropdownChanged2(int index, String? value) {
    // Do something with the value from the child's dropdown button
    /*stroski[index].produkt = value;

    print('Child $index dropdown value2 changed: $value');*/
  }

  void _onChildDropdownChanged3(int index, String? value) {
    // Do something with the value from the child's dropdown button
    /*stroski[index].kont = value;

    print('Child $index dropdown value3 changed: $value');*/
  }

  void _onChildFormSubmitted(
      int childIndex,
      String dropdownValue,
      String dropdownValue2,
      String dropdownValue3,
      String textFieldValue,
      String textFieldValue2) {
    print(
        'Child Widget ${childIndex + 1}  IS: $dropdownValue PRODUKT: $dropdownValue2 KOLIČINA: $textFieldValue KONT: $dropdownValue3 CENA: $textFieldValue2');

    stroski[childIndex + 1].kolicina = textFieldValue;
    stroski[childIndex + 1].cena = textFieldValue2;
    stroski[childIndex + 1].IS = dropdownValue;
    stroski[childIndex + 1].produkt = dropdownValue2;
    stroski[childIndex + 1].kont = dropdownValue3;

    var skupnaVrednostt = 0.0;

    setState(() {
      for (int i = 0; i < stroski.length; i++) {
        skupnaVrednostt = skupnaVrednostt + double.parse(stroski[i].cena);
        skupnaVrednost = skupnaVrednostt.toString();
      }
    });
  }

  String dropdownValue3 = '';
  String dropdownValue4 = '';
  String dropdownValue5 = '';

  DateTime kontDate = DateTime.now();
  DateTime rokDate = DateTime.now();

  String dobavitelj = '';
  String placilo = '';
  String obveznost = '';

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

  void _showDatePicker2() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        rokDate = value!;
      });
    });
  }

  bool isChecked = false;
  List<Strosek> stroski = [];
  bool dobaviteljChanged = false;
  bool placiloChanged = false;
  bool obveznostChanged = false;
  String skupnaVrednost = '0';

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.black;
    }

    return Container(
      width: 1700,
      height: 800,
      child: ListView(
        children: [
          Row(
            children: [
              Container(
                width: 340,
                height: 30,
                child: Text(
                  'DOBAVITELJ',
                  style: TextStyle(fontFamily: 'OpenSans'),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 340,
                height: 30,
                child: Text(
                  'KONT PLAČILA',
                  style: TextStyle(fontFamily: 'OpenSans'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 340,
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

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        }

                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;

                            List<dynamic> accountsJson = data['dobavitelji'];
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
                            dropdownValue4 = accountNames.first;
                            if (dobaviteljChanged == false) {
                              dobavitelj = accountNames.first;
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
                                value: dropdownValue4,
                                elevation: 16,
                                style: const TextStyle(fontFamily: 'OpenSans'),
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
                                    dropdownValue4 = value!;
                                    dobaviteljChanged = true;
                                  });
                                  dobavitelj = dropdownValue4;
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    )),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 340,
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

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                            dropdownValue3 = accountNames.first;
                            if (placiloChanged == false) {
                              placilo = accountNames.first;
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
                                    dropdownValue3 = value!;
                                    placiloChanged = true;
                                  });
                                  placilo = dropdownValue3;
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    )),
              ),
              Spacer(),
              Text(
                skupnaVrednost,
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 50),
              )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Container(
                width: 340,
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
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Container(
                width: 340,
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
            height: 60,
          ),
          Row(
            children: [
              Container(
                width: 340,
                height: 30,
                child: Text(
                  'INVENTAR/STORITEV',
                  style: TextStyle(fontFamily: 'OpenSans'),
                ),
              ),
              Container(
                width: 340,
                height: 30,
                child: Text(
                  'PRODUKT',
                  style: TextStyle(fontFamily: 'OpenSans'),
                ),
              ),
              Container(
                width: 340,
                height: 30,
                child: Text(
                  'KOLIČINA',
                  style: TextStyle(fontFamily: 'OpenSans'),
                ),
              ),
              Container(
                width: 340,
                height: 30,
                child: Text(
                  'KONT',
                  style: TextStyle(fontFamily: 'OpenSans'),
                ),
              ),
              Container(
                width: 340,
                height: 30,
                child: Text(
                  'CENA',
                  style: TextStyle(fontFamily: 'OpenSans'),
                ),
              ),
            ],
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _children.length,
            itemBuilder: (BuildContext context, int index) {
              return _children[index];
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: 150,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 150, height: 50),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(0)),
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              color: Colors.white))),
                      onPressed: () {
                        setState(() {
                          _children.add(
                            VnosVRacun(
                              onFormSubmitted: _onChildFormSubmitted,
                              index: _children.length - 1,
                              onTextChanged: (String value) {
                                _onChildTextChanged(
                                    _children.length - 1, value);
                              },
                              onTextChanged2: (String value) {
                                _onChildTextChanged2(
                                    _children.length - 1, value);
                              },
                              onDropdownChanged: (String? value) {
                                _onChildDropdownChanged(
                                    _children.length - 1, value);
                              },
                              onDropdownChanged2: (String? value) {
                                _onChildDropdownChanged2(
                                    _children.length - 1, value);
                              },
                              onDropdownChanged3: (String? value) {
                                _onChildDropdownChanged3(
                                    _children.length - 1, value);
                              },
                            ),
                          );
                          var uuid = Uuid();
                          Strosek str = Strosek(
                              ID: uuid.v1(),
                              IS: 'Inventar',
                              produkt: '',
                              kolicina: '0',
                              kont: '',
                              cena: '0');
                          stroski.add(str);
                        });
                      },
                      child: Text(
                        'DODAJ VRSTICO',
                        style: TextStyle(fontFamily: 'OpenSans'),
                      )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              Text(
                'Plačal bom pozneje.',
                style: TextStyle(fontFamily: 'OpenSans'),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (isChecked) ...[
            Row(
              children: [
                Container(
                  width: 340,
                  height: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 340,
                  height: 30,
                  child: Text(
                    'KONT OBVEZNOSTI',
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 340,
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
                          'Rok plačila',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 340,
                  height: 50,
                  child: SizedBox(
                      width: 340,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _usersStream2,
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
                              dropdownValue5 = accountNames.first;
                              if (obveznostChanged == false) {
                                obveznost = accountNames.first;
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
                                  value: dropdownValue5,
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
                                      dropdownValue5 = value!;
                                      obveznostChanged = true;
                                    });
                                    obveznost = dropdownValue5;
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        },
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Container(
                  width: 340,
                  child: Center(
                    child: Text(
                      "${rokDate.day}. ${rokDate.month}. ${rokDate.year}",
                      style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Spacer(),
              Container(
                width: 150,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 150, height: 50),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(0)),
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              color: Colors.white))),
                      onPressed: () {
                        //1. naredi racun za expense
                        //2. spremeni kont placila ce je placano takoj in dodaj transakcijo na kartico
                        //3. spremeni kolicine v inventarju/storitvah

                        ///1
                        var uuid = Uuid();
                        List<dynamic> stro = [];
                        for (int j = 0; j < stroski.length; j++) {
                          String s = jsonEncode(stroski[j]);
                          stro.add(s);
                        }

                        RacunStrosek novStrosek = RacunStrosek(
                            ID: uuid.v1(),
                            dobavitelj: dobavitelj,
                            kontPlacila: placilo,
                            datum: kontDate.toString(),
                            stroski: stro,
                            bilanca: skupnaVrednost,
                            placan: !isChecked,
                            rokPlacila: rokDate.toString(),
                            kontObveznost: obveznost);

                        List<RacunStrosek> stroskii = [];
                        var db = FirebaseFirestore.instance;
                        String ID = box.get('email');
                        final docRef = db.collection("Users").doc(ID);
                        docRef.get().then((DocumentSnapshot doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          List<dynamic> stroskiJson = data['stroski'];

                          for (int i = 0; i < stroskiJson.length; i++) {
                            Map<String, dynamic> valueMap =
                                json.decode(stroskiJson[i]);
                            RacunStrosek NewAccount =
                                RacunStrosek.fromJson(valueMap);
                            stroskii.add(NewAccount);
                          }

                          stroskii.add(novStrosek);
                          stroskiJson.add(jsonEncode(novStrosek));
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(ID)
                              .update({'stroski': stroskiJson});

                          //2
                          if (isChecked == false) {
                            List<Kont> konti = [];
                            List<Banka> banke = [];
                            List<VnosVDnevnik> vnosi = [];
                            List<Predmet> predmeti = [];
                            List<Storitev> storitve = [];
                            List<Dobavitelj> dobavitelji = [];
                            List<dynamic> bankaJson = data['banka'];
                            List<dynamic> kontiJson = data['konti'];
                            List<dynamic> vnosiJson = data['vnosi v dnevnik'];
                            List<dynamic> predmetiJson = data['predmeti'];
                            List<dynamic> storitveJson = data['storitve'];
                            List<dynamic> dobaviteljiJson = data['dobavitelji'];

                            for (int j = 0; j < bankaJson.length; j++) {
                              Map<String, dynamic> valueMap =
                                  json.decode(bankaJson[j]);
                              Banka NewAccount = Banka.fromJson(valueMap);
                              banke.add(NewAccount);
                            }

                            for (int jj = 0;
                                jj < dobaviteljiJson.length;
                                jj++) {
                              Map<String, dynamic> valueMap =
                                  json.decode(dobaviteljiJson[jj]);
                              Dobavitelj NewAccount =
                                  Dobavitelj.fromJson(valueMap);
                              dobavitelji.add(NewAccount);
                            }

                            for (int s = 0; s < storitveJson.length; s++) {
                              Map<String, dynamic> valueMap =
                                  json.decode(storitveJson[s]);
                              Storitev NewAccount = Storitev.fromJson(valueMap);
                              storitve.add(NewAccount);
                            }

                            for (int t = 0; t < predmetiJson.length; t++) {
                              Map<String, dynamic> valueMap =
                                  json.decode(predmetiJson[t]);
                              Predmet NewAccount = Predmet.fromJson(valueMap);
                              predmeti.add(NewAccount);
                            }

                            for (int k = 0; k < kontiJson.length; k++) {
                              Map<String, dynamic> valueMap =
                                  json.decode(kontiJson[k]);
                              Kont NewAccount = Kont.fromJson(valueMap);
                              konti.add(NewAccount);
                            }

                            for (int o = 0; o < vnosiJson.length; o++) {
                              Map<String, dynamic> valueMap =
                                  json.decode(vnosiJson[o]);
                              VnosVDnevnik NewAccount =
                                  VnosVDnevnik.fromJson(valueMap);
                              vnosi.add(NewAccount);
                            }

                            //dodaj transakcije in spremeni bilanco kartice
                            int indexBanka = banke.indexWhere(
                                (element) => element.ime == placilo);

                            for (int l = 0; l < stroski.length; l++) {
                              banke[indexBanka].transakcije.add(jsonEncode(
                                  Transakcija(
                                      ID: uuid.v1(),
                                      opis: '',
                                      datum: kontDate.toString(),
                                      kont: stroski[l].kont as String,
                                      prejemnikPlacila: dobavitelj,
                                      prejeto: '',
                                      placilo: stroski[l].cena)));
                            }

                            String oldStanje = banke[indexBanka].bilanca;
                            double newDouble = double.parse(oldStanje) -
                                double.parse(skupnaVrednost);
                            Banka old = banke[indexBanka];
                            banke[indexBanka] = Banka(
                                ID: old.ID,
                                ime: old.ime,
                                bilanca: newDouble.toString(),
                                transakcije: old.transakcije,
                                selected: false);

                            List<String> bankeJson = [];
                            for (int m = 0; m < banke.length; m++) {
                              bankeJson.add(jsonEncode(banke[m]));
                            }

                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'banka': bankeJson});

                            int dobaviteljIndex = dobavitelji.indexWhere(
                                (element) => element.naziv == dobavitelj);
                            Dobavitelj dobaviteljOld =
                                dobavitelji[dobaviteljIndex];
                            for (int ll = 0; ll < stroski.length; ll++) {
                              dobaviteljOld.transakcije.add(jsonEncode(
                                  Transakcija(
                                      ID: uuid.v1(),
                                      opis: '',
                                      datum: kontDate.toString(),
                                      kont: stroski[ll].kont as String,
                                      prejemnikPlacila: dobavitelj,
                                      prejeto: '',
                                      placilo: stroski[ll].cena)));
                            }
                            dobavitelji[dobaviteljIndex] = Dobavitelj(
                                ID: dobaviteljOld.ID,
                                naziv: dobaviteljOld.naziv,
                                naslov: dobaviteljOld.naslov,
                                tel: dobaviteljOld.tel,
                                email: dobaviteljOld.email,
                                bilanca: (double.parse(dobaviteljOld.bilanca) +
                                        double.parse(skupnaVrednost))
                                    .toString(),
                                transakcije: dobaviteljOld.transakcije);
                            //kreditiraj kont kartice in debitiraj konte inventarja/storitev
                            int kontBankaIndex = konti.indexWhere(
                                (element) => element.ime == placilo);

                            Kont oldBankaKont = konti[kontBankaIndex];
                            double oldBankaBalance =
                                double.parse(oldBankaKont.bilanca);
                            double newBankaBalance =
                                double.parse(skupnaVrednost);

                            String newBilancaString =
                                (oldBankaBalance - newBankaBalance).toString();

                            konti[kontBankaIndex] = Kont(
                                ID: oldBankaKont.ID,
                                ime: oldBankaKont.ime,
                                tip: oldBankaKont.tip,
                                podtip: oldBankaKont.podtip,
                                bilanca: newBilancaString,
                                amortizacija: oldBankaKont.amortizacija,
                                bilancaDate: oldBankaKont.bilancaDate,
                                amortizacijaDate: oldBankaKont.amortizacijaDate,
                                debet: oldBankaKont.debet,
                                kredit: (double.parse(oldBankaKont.kredit) +
                                        double.parse(skupnaVrednost))
                                    .toString());

                            List<String> predmettiJson = [];
                            List<String> storittveJson = [];

                            for (int n = 0; n < stroski.length; n++) {
                              String imeKontaStroska =
                                  stroski[n].kont as String;
                              int indexKonta = konti.indexWhere(
                                  (element) => element.ime == imeKontaStroska);
                              Kont oldInventarKont = konti[indexKonta];
                              konti[indexKonta] = Kont(
                                  ID: oldInventarKont.ID,
                                  ime: oldInventarKont.ime,
                                  tip: oldInventarKont.tip,
                                  podtip: oldInventarKont.podtip,
                                  bilanca:
                                      (double.parse(oldInventarKont.bilanca) +
                                              double.parse(stroski[n].cena))
                                          .toString(),
                                  amortizacija: oldInventarKont.amortizacija,
                                  bilancaDate: oldInventarKont.bilancaDate,
                                  amortizacijaDate:
                                      oldInventarKont.amortizacijaDate,
                                  kredit: oldInventarKont.kredit,
                                  debet: (double.parse(oldInventarKont.debet) +
                                          double.parse(stroski[n].cena))
                                      .toString());
                              //Vnosi v dnevnik
                              vnosiJson.add(jsonEncode(VnosVDnevnik(
                                  datum: kontDate.toString(),
                                  debet: stroski[n].cena,
                                  kredit: stroski[n].cena,
                                  kontDebet: stroski[n].kont as String,
                                  kontKredit: placilo,
                                  komentar: '',
                                  id: uuid.v1())));

                              //spremeni kolicine inventarja
                              if (stroski[n].IS == 'Inventar') {
                                int inventarIndex = predmeti.indexWhere(
                                    (element) =>
                                        element.ime == stroski[n].produkt);
                                double oldKolicina = double.parse(
                                        predmeti[inventarIndex].kolicina) +
                                    double.parse(stroski[n].kolicina);
                                Predmet predmetOld = predmeti[inventarIndex];
                                predmeti[inventarIndex] = Predmet(
                                    kont: stroski[n].kont as String,
                                    ID: predmetOld.ID,
                                    ime: predmetOld.ime,
                                    kolicina: oldKolicina.toString(),
                                    enota: predmetOld.enota,
                                    slika: predmetOld.slika,
                                    bilanca: (double.parse(predmetOld.bilanca) +
                                            double.parse(stroski[n].cena))
                                        .toString(),
                                    tip: predmetOld.tip);
                              } else {
                                int inventarIndex = storitve.indexWhere(
                                    (element) =>
                                        element.ime == stroski[n].produkt);

                                double oldKolicina = double.parse(
                                        storitve[inventarIndex].stnakupov) +
                                    double.parse(stroski[n].kolicina);

                                Storitev storitevOld = storitve[inventarIndex];
                                storitve[inventarIndex] = Storitev(
                                    ID: storitevOld.ID,
                                    ime: storitevOld.ime,
                                    dobavitelj: storitevOld.dobavitelj,
                                    komentar: storitevOld.komentar,
                                    stnakupov: oldKolicina.toString(),
                                    bilanca:
                                        (double.parse(storitevOld.bilanca) +
                                                double.parse(stroski[n].cena))
                                            .toString());
                              }
                            }

                            List<String> storiitveJson = [];
                            for (int mm = 0; mm < storitve.length; mm++) {
                              storiitveJson.add(jsonEncode(storitve[mm]));
                            }

                            for (int m = 0; m < predmeti.length; m++) {
                              predmettiJson.add(jsonEncode(predmeti[m]));
                            }
                            List<String> kontiJsonn = [];
                            for (int p = 0; p < konti.length; p++) {
                              kontiJsonn.add(jsonEncode(konti[p]));
                            }

                            List<String> dobaviteljiJsonn = [];
                            for (int pp = 0; pp < dobavitelji.length; pp++) {
                              dobaviteljiJsonn.add(jsonEncode(dobavitelji[pp]));
                            }

                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'dobavitelji': dobaviteljiJsonn});

                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'storitve': storiitveJson});
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'predmeti': predmettiJson});
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'konti': kontiJsonn});
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'vnosi v dnevnik': vnosiJson});
                            //spremeni kolicine v inventarju/storitvah
                          } else {
                            //kreditiraj kont obveznosti in dodaj izdelke v inventarju in spremeni njihove konte
                            List<Kont> konti = [];
                            List<Banka> banke = [];
                            List<VnosVDnevnik> vnosi = [];
                            List<Predmet> predmeti = [];
                            List<Storitev> storitve = [];
                            List<dynamic> bankaJson = data['banka'];
                            List<dynamic> kontiJson = data['konti'];
                            List<dynamic> vnosiJson = data['vnosi v dnevnik'];
                            List<dynamic> predmetiJson = data['predmeti'];
                            List<dynamic> storitveJson = data['storitve'];

                            for (int j = 0; j < bankaJson.length; j++) {
                              Map<String, dynamic> valueMap =
                                  json.decode(bankaJson[j]);
                              Banka NewAccount = Banka.fromJson(valueMap);
                              banke.add(NewAccount);
                            }

                            for (int s = 0; s < storitveJson.length; s++) {
                              Map<String, dynamic> valueMap =
                                  json.decode(storitveJson[s]);
                              Storitev NewAccount = Storitev.fromJson(valueMap);
                              storitve.add(NewAccount);
                            }

                            for (int t = 0; t < predmetiJson.length; t++) {
                              Map<String, dynamic> valueMap =
                                  json.decode(predmetiJson[t]);
                              Predmet NewAccount = Predmet.fromJson(valueMap);
                              predmeti.add(NewAccount);
                            }

                            for (int k = 0; k < kontiJson.length; k++) {
                              Map<String, dynamic> valueMap =
                                  json.decode(kontiJson[k]);
                              Kont NewAccount = Kont.fromJson(valueMap);
                              konti.add(NewAccount);
                            }

                            for (int o = 0; o < vnosiJson.length; o++) {
                              Map<String, dynamic> valueMap =
                                  json.decode(vnosiJson[o]);
                              VnosVDnevnik NewAccount =
                                  VnosVDnevnik.fromJson(valueMap);
                              vnosi.add(NewAccount);
                            }

                            //namesto iz banke se kreditira kont obveznosti
                            //dobimo storitev ali predmet v inventar
                            int obveznostKontIndex = konti.indexWhere(
                                (element) => element.ime == obveznost);

                            Kont obveznostOld = konti[obveznostKontIndex];
                            konti[obveznostKontIndex] = Kont(
                                ID: obveznostOld.ID,
                                ime: obveznostOld.ime,
                                tip: obveznostOld.tip,
                                podtip: obveznostOld.podtip,
                                bilanca: (double.parse(obveznostOld.bilanca) -
                                        double.parse(skupnaVrednost))
                                    .toString(),
                                amortizacija: obveznostOld.amortizacija,
                                bilancaDate: obveznostOld.bilancaDate,
                                amortizacijaDate: obveznostOld.amortizacijaDate,
                                debet: obveznostOld.debet,
                                kredit: (double.parse(obveznostOld.kredit) +
                                        double.parse(skupnaVrednost))
                                    .toString());

                            List<String> predmettiJson = [];
                            List<String> storittveJson = [];

                            for (int n = 0; n < stroski.length; n++) {
                              String imeKontaStroska =
                                  stroski[n].kont as String;
                              int indexKonta = konti.indexWhere(
                                  (element) => element.ime == imeKontaStroska);
                              Kont oldInventarKont = konti[indexKonta];
                              konti[indexKonta] = Kont(
                                  ID: oldInventarKont.ID,
                                  ime: oldInventarKont.ime,
                                  tip: oldInventarKont.tip,
                                  podtip: oldInventarKont.podtip,
                                  bilanca:
                                      (double.parse(oldInventarKont.bilanca) +
                                              double.parse(stroski[n].cena))
                                          .toString(),
                                  amortizacija: oldInventarKont.amortizacija,
                                  bilancaDate: oldInventarKont.bilancaDate,
                                  amortizacijaDate:
                                      oldInventarKont.amortizacijaDate,
                                  kredit: oldInventarKont.kredit,
                                  debet: (double.parse(oldInventarKont.debet) +
                                          double.parse(stroski[n].cena))
                                      .toString());
                              //Vnosi v dnevnik
                              vnosiJson.add(jsonEncode(VnosVDnevnik(
                                  datum: kontDate.toString(),
                                  debet: stroski[n].cena,
                                  kredit: stroski[n].cena,
                                  kontDebet: stroski[n].kont as String,
                                  kontKredit: placilo,
                                  komentar: '',
                                  id: uuid.v1())));

                              //spremeni kolicine inventarja
                              if (stroski[n].IS == 'Inventar') {
                                int inventarIndex = predmeti.indexWhere(
                                    (element) =>
                                        element.ime == stroski[n].produkt);
                                double oldKolicina = double.parse(
                                        predmeti[inventarIndex].kolicina) +
                                    double.parse(stroski[n].kolicina);
                                Predmet predmetOld = predmeti[inventarIndex];
                                predmeti[inventarIndex] = Predmet(
                                    kont: predmetOld.kont,
                                    ID: predmetOld.ID,
                                    ime: predmetOld.ime,
                                    kolicina: oldKolicina.toString(),
                                    enota: predmetOld.enota,
                                    slika: predmetOld.slika,
                                    bilanca: (double.parse(predmetOld.bilanca) +
                                            double.parse(stroski[n].cena))
                                        .toString(),
                                    tip: predmetOld.tip);
                              } else {
                                int inventarIndex = storitve.indexWhere(
                                    (element) =>
                                        element.ime == stroski[n].produkt);

                                double oldKolicina = double.parse(
                                        storitve[inventarIndex].stnakupov) +
                                    double.parse(stroski[n].kolicina);

                                Storitev storitevOld = storitve[inventarIndex];
                                storitve[inventarIndex] = Storitev(
                                    ID: storitevOld.ID,
                                    ime: storitevOld.ime,
                                    dobavitelj: storitevOld.dobavitelj,
                                    komentar: storitevOld.komentar,
                                    stnakupov: oldKolicina.toString(),
                                    bilanca:
                                        (double.parse(storitevOld.bilanca) +
                                                double.parse(stroski[n].cena))
                                            .toString());
                              }
                            }

                            List<String> storiitveJson = [];
                            for (int mm = 0; mm < storitve.length; mm++) {
                              storiitveJson.add(jsonEncode(storitve[mm]));
                            }

                            for (int m = 0; m < predmeti.length; m++) {
                              predmettiJson.add(jsonEncode(predmeti[m]));
                            }
                            List<String> kontiJsonn = [];
                            for (int p = 0; p < konti.length; p++) {
                              kontiJsonn.add(jsonEncode(konti[p]));
                            }

                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'storitve': storiitveJson});
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'predmeti': predmettiJson});
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'konti': kontiJsonn});
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'vnosi v dnevnik': vnosiJson});
                          }
                        });
                      },
                      child: Text(
                        'DODAJ',
                        style: TextStyle(fontFamily: 'OpenSans'),
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
