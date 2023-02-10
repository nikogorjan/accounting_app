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
    String ret = 'Patenti, licence, industrijska lastnina in drugo.';

    if (subtype == 'Neopredmetena dolgoročna sredstva') {
      ret = 'Patenti, licence, industrijska lastnina in drugo.';
    } else if (subtype == 'Opredmetena osnovna sredstva') {
      ret =
          'Zemljišča, zgradbe, oprema, stroji, transportna sredstva, večletni nasadi, osnovna čreda in drugo.';
    } else if (subtype == 'Dolgoročne finančne naložbe') {
      ret = 'Dana dolgoročna posojila, kupljeni dolgoročni vrednostni papirji.';
    } else if (subtype == 'Zaloge') {
      ret =
          'Surovine, material, nedokončane proizvodnje, polproizvodi, gotovi proizvodi, trgovsko blago.';
    } else if (subtype == 'Kratkoročne terjatve iz poslovanja') {
      ret =
          'Terjatve do kupcev, katerim smo na osnovi premoženjsko-pravnih in drugih razmerij prodali proizvode, blago ali opravili storitve na odložen rok plačila.';
    } else if (subtype == 'Kratkoročne finančne naložbe') {
      ret =
          'Dana kratkoročna posojila, kupljeni kratkoročni vrednostni papirji.';
    } else if (subtype == 'Denarna sredstva') {
      ret =
          'Denarna sredstva v blagajni in dobroimetje na računih v bankah in drugih finančnih institucijah, ki jih delimo na tuja in domača denarna sredstva.';
    } else if (subtype == 'Aktivne časovne omejitve') {
      ret =
          'Kratkoročno odloženi stroški, to so odhodki, so vnaprej plačani zneski, ki ob plačilu še ne morejo bremeniti dejavnosti podjetja in vplivati na poslovni izid; ob plačilu jih še ne moremo všteti v nabavne vrednosti opredmetenih osnovnih sredstev ali zalog.';
    } else if (subtype == 'Dolgoročne rezervacije') {
      ret =
          'Dolgoročno rezervirane obveznosti, ki lahko nastanejona podlagi sklenjenih pravnih poslov ali na kakšni drugi pravni podlagi oziroma zanje vsaj utemeljeno, na podlagi izkušenj ali stroškovnih ocen pričakujemo, da bodo nastale čez več kot eno leto.';
    } else if (subtype == 'Dolgoročne obveznosti iz financiranja') {
      ret =
          'Obveznosti, ki zapadejo v plačilo v roku, ki je daljši od leta dni. To so dolgoročna dobljena posojila in izdani dolgoročni vrednostni papirji - obveznice.';
    } else if (subtype == 'Dolgoročne obveznosti iz poslovanja') {
      ret =
          'So dolgoročne obveznosti v zvezi s kuplenim blagom ali storitvami, ki jih lahko imamo do domačih ali tujih pravnih in fizičnih oseb.';
    } else if (subtype == 'Kratkoročne obveznosti iz financiranja') {
      ret =
          'Te zapadejo v plačilo v letu dni ali prej. To so kratkoročno dobljena posojila, izdani kratkoročni vrednostni papirji - zlasti menice.';
    } else if (subtype == 'Kratkoročne obveznosti iz poslovanja') {
      ret =
          'Obveznosti, ki zapadejo v plačilo v letu dni ali prej. To so dobljeni avansi od kupcev, kratkoročne obveznosti do dobaviteljev doma in v tujini, obveznosti do države in do delavcev.';
    } else if (subtype == 'Pasivne časovne razmejitve') {
      ret =
          'Vnaprej vračunani stroški, torej odhodki, so stroški, s katerimi podjetje enakomerno obremenjuje svojo dejavnost ali zaloge oziroma odhodki, s katerimi enakomerno obremenjuje svoj poslovni izid. Niso se še pojavili so pa pričakovani.';
    } else if (subtype == 'Osnovni kapital') {
      ret =
          'Je nominalno določen v družbeni pogodbi, statutu ali ali drugem ustanovnem aktu podjetja, vpisujejo ali vplačujejo ga lastniki v sodni register.';
    } else if (subtype == 'Finančni kapital') {
      ret = 'Čisto premoženje podjetja.';
    } else if (subtype == 'Celotni kapital') {
      ret =
          'Osnovni kapital povečan za ves pripadajoči lastniški kapital in obveznost podjetja do lastnikov.';
    } else if (subtype == 'Poslovni prihodki') {
      ret =
          'Peodajne vrednosti poslovnih učinkov, ki so dosežene v poslovnem letu, so zmnožek količine proizvodov in storitev s prodajnimi cenami.';
    } else if (subtype == 'Finančni prihodki') {
      ret =
          'Obresti za dana posojila, zamujene obresti, dobljene dividende, prihodki od prodaje finančnih naložb, pozitivne tečajne razlike.';
    } else if (subtype == 'Izredni prihodki') {
      ret =
          'Blagajniški ali inventurni presežki, izterjane odpisane terjatve, dobljene subvencije, dotacije, prejete kazni in odškodnine.';
    } else if (subtype == 'Poslovni odhodki') {
      ret =
          'Stroški materiala, surovin, tujih in lastnih storitev, amortizacije, plače, nabavne vrednosti trgovskega blaga in druge.';
    } else if (subtype == 'Prevrednotovalni odhodki') {
      ret =
          'Odpisi terjatev, izgube pri prodaji opredmetenih osnovnih sredstev, oslabitve sredstev in druge.';
    } else if (subtype == 'Finančni odhodki') {
      ret =
          'Obresti za posojila, zamude obresti od dobaviteljev, negativne tečajne razlike, odhodki od prodaje finančnih naložb, povečanje dolgoročnih rezervacij, prevrednotovalni finančni odhodki.';
    } else if (subtype == 'Izredni odhodki') {
      ret =
          'Blagajniški in inventurni manjki, kritje izgub iz preteklih let, denarne kazni in odškodnine, oblikovanje rezervacij za kritje možne izgube iz posameznih poslov in druge.';
    }

    return ret;
  }

  String returnSubtypeString(String tip) {
    String podtip = '';
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
      podtip = stalnaSredstva.first;
    } else if (tip == 'Gibljiva sredstva') {
      podtip = gibljivaSredstva.first;
    } else if (tip == 'Kapital') {
      podtip = kapital.first;
    } else if (tip == 'Obveznosti') {
      podtip = obveznosti.first;
    } else if (tip == 'Prihodki') {
      podtip = prihodki.first;
    } else if (tip == 'Odhodki') {
      podtip = odhodki.first;
    }

    return podtip;
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
                      dropdownValue2notifier.value =
                          returnSubtypeString(dropdownValue);
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
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(217, 234, 250, 0.2),
                        borderRadius: BorderRadius.all(Radius.circular(
                                0) //                 <--- border radius here
                            ),
                        border: Border.all(color: Colors.grey)),
                    width: 360,
                    padding: EdgeInsets.all(8.0),
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
