//import 'dart:ffi';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/kont.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({super.key});

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _IDController = TextEditingController();
  final _imeController = TextEditingController();
  final _bilancaController = TextEditingController();
  final _amortizacijaController = TextEditingController();
  List<String> tip = <String>[
    'Stalna sredstva',
    'Gibljiva sredstva',
    'Obveznosti',
    'Kapital',
    'Prihodki',
    'Odhodki'
  ];
  String dropdownValue = 'Stalna sredstva';
  final ValueNotifier<String> dropdownValue2notifier =
      ValueNotifier<String>('Default Text');
  late String dropdownValue2;

  List<String> returnSubType(String tip) {
    List<String> podtip = [];
    List<String> stalnaSredstva = [
      'Neopredmetena dolgoročna sredstva',
      'Opredmetena osnovna sredstva',
      'Dolgoročne finančne naložbe'
    ];
    List<String> gibljivaSredstva = [
      'Zaloge',
      'Kratkoročne terjatve iz poslovanja',
      'Kratkoročne finančne naložbe',
      'Denarna sredstva',
      'Aktivne časovne omejitve'
    ];
    List<String> kapital = [
      'Osnovni kapital',
      'Finančni kapital',
      'Celotni kapital',
    ];
    List<String> obveznosti = [
      'Dolgoročne rezervacije',
      'Dolgoročne obveznosti iz financiranja',
      'Dolgoročne obveznosti iz poslovanja',
      'Kratkoročne obveznosti iz financiranja',
      'Kratkoročne obveznosti iz poslovanja',
      'Pasivne časovne razmejitve'
    ];
    List<String> prihodki = [
      'Poslovni prihodki',
      'Finančni prihodki',
      'Izredni prihodki',
    ];
    List<String> odhodki = [
      'Poslovni odhodki',
      'Prevrednotovalni odhodki',
      'Finančni odhodki',
      'Izredni odhodki'
    ];

    if (tip == 'Stalna sredstva') {
      podtip = stalnaSredstva;
    } else if (tip == 'Gibljiva sredstva') {
      podtip = gibljivaSredstva;
    } else if (tip == 'Kapital') {
      podtip = kapital;
    } else if (tip == 'Obveznosti') {
      podtip = obveznosti;
    } else if (tip == 'Prihodki') {
      podtip = prihodki;
    } else if (tip == 'Odhodki') {
      podtip = odhodki;
    }

    return podtip;
  }

  DateTime kontDate = DateTime.now();
  DateTime amortizacijaDate = DateTime.now();

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

  void _showDatePickerAmortizacija() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        amortizacijaDate = value!;
      });
    });
  }

  String showAccountDescription(String subtype) {
    String ret = '';

    if (subtype == 'Neopredmetena dolgoročna sredstva') {
      ret = 'Neopredmetena dolgoročna';
    } else if (subtype == 'Opredmetena osnovna sredstva') {
      ret = 'Opredmetena osnovna';
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: 1200,
      height: 700,
      child: Row(
        children: [
          Expanded(
              child: Container(
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _IDController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      hintText: 'ID',
                      hintStyle: TextStyle(
                          fontFamily: 'OpenSans', color: Colors.black)),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Text(
                      '0 - ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'Dolgoročna sredstva;',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '1 - ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'Kratkoročna sredstva, razen zalog',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '      ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'in aktivne časovne omejitve;',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '2 - ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'Kratkoročne obveznosti (dolgovi)',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '      ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'in pasivne časovne omejitve;',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '3 - ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'Zaloge surovin in materiala;',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '4 - ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'Stroški;',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '5 - ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'Ni definiran (prosta uporaba);',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '6 - ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'Zaloge proizvodov in blaga;',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '7 - ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'Odhodki in prihodki;',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '8 - ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'Poslovni izid;',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      '9 - ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'Kapital, dolgoročne obveznosti (dolgovi)',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '      ',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    Text(
                      'in dolgoročne rezervacije;',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Text(
                      'Kontni okvir po slovenskih standardih.',
                      style: TextStyle(
                          fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            ),
          )),
          const VerticalDivider(
            width: 40,
          ),
          //tip in podtip
          Expanded(
              child: Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  width: 360,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5)),
                    ),
                    value: dropdownValue,
                    elevation: 16,
                    style: const TextStyle(fontFamily: 'OpenSans'),
                    items: tip.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              fontFamily: 'OpenSans', color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 360,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5)),
                    ),
                    value: dropdownValue2 = returnSubType(dropdownValue).first,
                    elevation: 16,
                    style: const TextStyle(fontFamily: 'OpenSans'),
                    items: returnSubType(dropdownValue)
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              fontFamily: 'OpenSans', color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue2 = value!;
                      });
                      dropdownValue2notifier.value = dropdownValue2;
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: Container(
                    width: 360,
                    padding: EdgeInsets.all(8.0),
                    color: Color.fromRGBO(217, 234, 250, 0.2),
                    child: ValueListenableBuilder(
                      valueListenable: dropdownValue2notifier,
                      builder: (context, value, child) {
                        return Text(showAccountDescription(
                            dropdownValue2notifier.value));
                      },
                    ),
                  ),
                )
              ],
            ),
          )),
          const VerticalDivider(
            width: 40,
          ),
          Expanded(
              child: Container(
            child: Column(
              children: [
                TextField(
                  controller: _bilancaController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      hintText: 'Začetna bilanca',
                      hintStyle: TextStyle(
                          fontFamily: 'OpenSans', color: Colors.black)),
                ),
                SizedBox(
                  height: 20,
                ),
                ConstrainedBox(
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
                        'Izberi začetni datum',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "${kontDate.day}. ${kontDate.month}. ${kontDate.year}",
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                ),
                SizedBox(
                  height: 40,
                ),
                if (dropdownValue == 'Stalna sredstva') ...[
                  TextField(
                    controller: _amortizacijaController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        hintText: 'Amortizacija',
                        hintStyle: TextStyle(
                            fontFamily: 'OpenSans', color: Colors.black)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 200, height: 25),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xEEEEEEEE),
                      ),
                      onPressed: _showDatePickerAmortizacija,
                      child: Center(
                        child: Text(
                          'Izberi začetni datum',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "${amortizacijaDate.day}. ${amortizacijaDate.month}. ${amortizacijaDate.year}",
                    style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                  ),
                ],
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _imeController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      hintText: 'Ime',
                      hintStyle: TextStyle(
                          fontFamily: 'OpenSans', color: Colors.black)),
                ),
                SizedBox(
                  height: 40,
                ),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 150, height: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      List<Kont> accounts = [];
                      var db = FirebaseFirestore.instance;
                      String ID = box.get('email');
                      final docRef = db.collection("Users").doc(ID);
                      docRef.get().then((DocumentSnapshot doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        List<dynamic> accountsJson = data['konti'];

                        for (int i = 0; i < accountsJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(accountsJson[i]);
                          Kont NewAccount = Kont.fromJson(valueMap);
                          accounts.add(NewAccount);
                        }
                        Kont kon;
                        if (dropdownValue == 'Stalna sredstva') {
                          kon = Kont(
                              ID: _IDController.text.trim(),
                              ime: _imeController.text.trim(),
                              tip: dropdownValue,
                              podtip: dropdownValue2,
                              bilanca: _bilancaController.text.trim(),
                              amortizacija: _amortizacijaController.text.trim(),
                              bilancaDate: kontDate.toString(),
                              amortizacijaDate: amortizacijaDate.toString());
                        } else {
                          kon = Kont(
                              ID: _IDController.text.trim(),
                              ime: _imeController.text.trim(),
                              tip: dropdownValue,
                              podtip: dropdownValue2,
                              bilanca: _bilancaController.text.trim(),
                              amortizacija: 'NULL',
                              bilancaDate: kontDate.toString(),
                              amortizacijaDate: 'NULL');
                        }

                        accounts.add(kon);
                        List<String> kontiJson = [];
                        for (int i = 0; i < accounts.length; i++) {
                          kontiJson.add(jsonEncode(accounts[i]));
                        }
                        String ID = box.get('email');
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(ID)
                            .update({'konti': kontiJson});
                      }, onError: (e) => print("Error getting document: $e"));
                    },
                    child: Text('Dodaj'),
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
                )
              ],
            ),
            color: Colors.white,
          )),
        ],
      ),
    );
  }
}
