import 'dart:convert';

import 'package:accounting_app/gradniki/prodaja/vnos_v_racun_prodaja.dart';
import 'package:accounting_app/gradniki/prodaja/vnos_v_racun_prodaja_mobile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uuid/uuid.dart';

import '../../api/pdf_invoice_api.dart';
import '../../data/data.dart';
import '../../objekti/banka.dart';
import '../../objekti/invoice.dart';
import '../../objekti/kont.dart';
import '../../objekti/predmet.dart';
import '../../objekti/prodaja.dart';
import '../../objekti/produkt_storitev.dart';
import '../../objekti/racun_prodaja.dart';
import '../../objekti/racun_strosek.dart';
import '../../objekti/storitev.dart';
import '../../objekti/stranka.dart';
import '../../objekti/strosek.dart';
import '../../objekti/transakcija.dart';
import '../../objekti/vnos_v_dnevnik.dart';
import '../../services/storage_service.dart';

class ProdajaDodajRacunMobile extends StatefulWidget {
  const ProdajaDodajRacunMobile({super.key});

  @override
  State<ProdajaDodajRacunMobile> createState() =>
      _ProdajaDodajRacunMobileState();
}

class _ProdajaDodajRacunMobileState extends State<ProdajaDodajRacunMobile> {
  String naslovPodjetja = '';
  String imeProdajalca = '';
  String firmaProdajalca = '';
  String _childText = '';
  String? _dropdownValue;
  List<VnosVRacunProdajaMobile> _children = [];
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  final Stream<QuerySnapshot> _usersStream2 = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  String dobavitelj = '';
  String placilo = '';
  String obveznost = '';
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

  String dropdownValue3 = '';
  String dropdownValue4 = '';
  String dropdownValue5 = '';

  bool isChecked = false;
  List<Prodaja> prodaje = [];
  bool dobaviteljChanged = false;
  bool placiloChanged = false;
  bool obveznostChanged = false;
  String skupnaVrednost = '0';

  void _onChildFormSubmitted(
      int childIndex,
      String dropdownValue,
      String dropdownValue2,
      String tip,
      String textFieldValue1,
      String textFieldValue2,
      String textFieldValue3,
      String textFieldValue4) {
    print(
        'Child Widget ${childIndex + 1}  PS: $dropdownValue KONT: $dropdownValue2 TIP: $tip KOLIČIN: $textFieldValue1 CENA: $textFieldValue2 VSOTA: $textFieldValue3 DDV: $textFieldValue4%');

    prodaje[childIndex + 1].PS = dropdownValue;
    prodaje[childIndex + 1].kolicina = textFieldValue1;
    prodaje[childIndex + 1].cena = textFieldValue2;
    prodaje[childIndex + 1].vsota = textFieldValue3;
    prodaje[childIndex + 1].tip = tip;
    prodaje[childIndex + 1].kont = dropdownValue2;
    prodaje[childIndex + 1].DDV = textFieldValue4;

    var skupnaVrednostt = 0.0;

    for (int i = 0; i < prodaje.length; i++) {
      skupnaVrednostt =
          skupnaVrednostt + double.parse(prodaje[i].vsota as String);
      setState(() {
        skupnaVrednost = skupnaVrednostt.toStringAsFixed(2);
      });
    }
  }

  String dropdownValue9 = '';
  bool changed = false;
  String kontPlaniranja = '';

  String dropdownValue10 = '';
  bool changed10 = false;
  String kontDavki = '';

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
      width: 300,
      height: 500,
      child: ListView(
        children: [
          Container(
            width: 260,
            height: 30,
            child: Text(
              'STRANKA',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
          ),
          Container(
            width: 260,
            height: 70,
            child: SizedBox(
                width: 260,
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
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        List<dynamic> accountsJson = data['stranke'];
                        List<Stranka> accounts = [];
                        List<String> accountNames = [];
                        for (int i = 0; i < accountsJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(accountsJson[i]);
                          Stranka NewAccount = Stranka.fromJson(valueMap);
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
                          width: 260,
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
                            value: dropdownValue4,
                            elevation: 16,
                            style: const TextStyle(fontFamily: 'OpenSans'),
                            items: accountNames
                                .map<DropdownMenuItem<String>>((String value) {
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
            height: 30,
            child: Text(
              'KONT PREJEMA PLAČILA',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
          ),
          Container(
            width: 260,
            height: 70,
            child: SizedBox(
                width: 260,
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
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
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
                          width: 260,
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
                            value: dropdownValue3,
                            elevation: 16,
                            style: const TextStyle(fontFamily: 'OpenSans'),
                            items: accountNames
                                .map<DropdownMenuItem<String>>((String value) {
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
          Container(
            width: 260,
            height: 30,
            child: Text(
              'KONT STROŠKA PRODAJE',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
          ),
          Container(
            width: 260,
            height: 70,
            child: SizedBox(
                width: 260,
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
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
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
                        dropdownValue9 = accountNames.first;
                        if (changed == false) {
                          kontPlaniranja = accountNames.first;
                        }

                        //debetItem = dropdownValue;

                        return Container(
                          width: 260,
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
                            value: dropdownValue3,
                            elevation: 16,
                            style: const TextStyle(fontFamily: 'OpenSans'),
                            items: accountNames
                                .map<DropdownMenuItem<String>>((String value) {
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
                                dropdownValue9 = value!;
                                changed = true;
                              });
                              kontPlaniranja = dropdownValue9;
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                )),
          ),
          Container(
            width: 260,
            height: 30,
            child: Text(
              'KONT DAVKOV',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
          ),
          Container(
            width: 260,
            height: 70,
            child: SizedBox(
                width: 260,
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
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
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
                        dropdownValue10 = accountNames.first;
                        if (changed10 == false) {
                          kontDavki = accountNames.first;
                        }

                        //debetItem = dropdownValue;

                        return Container(
                          width: 260,
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
                            value: dropdownValue10,
                            elevation: 16,
                            style: const TextStyle(fontFamily: 'OpenSans'),
                            items: accountNames
                                .map<DropdownMenuItem<String>>((String value) {
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
                                dropdownValue10 = value!;
                                changed10 = true;
                              });
                              kontDavki = dropdownValue10;
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                )),
          ),
          Row(
            children: [
              Container(
                width: 260,
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
                width: 260,
                child: Center(
                  child: Text(
                    "${kontDate.day}. ${kontDate.month}. ${kontDate.year}",
                    style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _children.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  _children[index]
                ],
              );
            },
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
                            VnosVRacunProdajaMobile(
                              onFormSubmitted: _onChildFormSubmitted,
                              index: _children.length - 1,
                            ),
                          );
                          var uuid = Uuid();
                          Prodaja str = Prodaja(
                              kont: '',
                              tip: '',
                              ID: uuid.v1(),
                              PS: 'PS',
                              DDV: 0.toDouble().toStringAsFixed(2),
                              kolicina: 0.toDouble().toStringAsFixed(2),
                              cena: 0.toDouble().toStringAsFixed(2),
                              vsota: 0.toDouble().toStringAsFixed(2));
                          prodaje.add(str);
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
          Text(
            skupnaVrednost,
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 50),
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
                        //1. naredi racun za prodajo
                        var uuid = Uuid();
                        List<dynamic> pro = [];
                        for (int j = 0; j < prodaje.length; j++) {
                          String s = jsonEncode(prodaje[j]);
                          pro.add(s);
                        }

                        RacunProdaja novaProdaja = RacunProdaja(
                            ID: uuid.v1(),
                            stranka: dobavitelj,
                            kontprodaje: placilo,
                            datum: kontDate.toString(),
                            prodaje: pro,
                            bilanca: skupnaVrednost,
                            placan: !isChecked,
                            rokPlacila: rokDate.toString(),
                            kontterjatev: obveznost);

                        List<RacunProdaja> prodajee = [];
                        var db = FirebaseFirestore.instance;
                        String ID = box.get('email');
                        final docRef = db.collection("Users").doc(ID);
                        docRef.get().then((DocumentSnapshot doc) async {
                          final data = doc.data() as Map<String, dynamic>;
                          List<dynamic> prodajaJson = data['prodaja'];

                          imeProdajalca = data['ime'];
                          firmaProdajalca = data['naziv podjetja'];
                          naslovPodjetja = data['sedez podjetja'];

                          for (int i = 0; i < prodajaJson.length; i++) {
                            Map<String, dynamic> valueMap =
                                json.decode(prodajaJson[i]);
                            RacunProdaja NewAccount =
                                RacunProdaja.fromJson(valueMap);
                            prodajee.add(NewAccount);
                          }

                          prodajee.add(novaProdaja);
                          prodajaJson.add(jsonEncode(novaProdaja));
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(ID)
                              .update({'prodaja': prodajaJson});

                          List<Kont> konti = [];
                          List<Banka> banke = [];
                          List<VnosVDnevnik> vnosi = [];
                          List<Predmet> predmeti = [];
                          List<Storitev> storitve = [];
                          List<ProduktStoritev> PS = [];
                          List<Stranka> stranke = [];
                          List<RacunStrosek> stroski = [];

                          List<dynamic> bankaJson = data['banka'];
                          List<dynamic> kontiJson = data['konti'];
                          List<dynamic> vnosiJson = data['vnosi v dnevnik'];
                          List<dynamic> predmetiJson = data['predmeti'];
                          List<dynamic> storitveJson = data['storitve'];
                          List<dynamic> PSJson = data['produkti in storitve'];
                          List<dynamic> strankeJson = data['stranke'];
                          List<dynamic> stroskiJson = data['stroski'];

                          for (int j = 0; j < stroskiJson.length; j++) {
                            Map<String, dynamic> valueMap =
                                json.decode(stroskiJson[j]);
                            RacunStrosek NewAccount =
                                RacunStrosek.fromJson(valueMap);
                            stroski.add(NewAccount);
                          }

                          for (int jjj = 0; jjj < strankeJson.length; jjj++) {
                            Map<String, dynamic> valueMap =
                                json.decode(strankeJson[jjj]);
                            Stranka NewAccount = Stranka.fromJson(valueMap);
                            stranke.add(NewAccount);
                          }

                          int indexStranka = stranke.indexWhere(
                              (element) => element.naziv == dobavitelj);
                          Stranka stranka = stranke[indexStranka];

                          for (int jj = 0; jj < PSJson.length; jj++) {
                            Map<String, dynamic> valueMap =
                                json.decode(PSJson[jj]);
                            ProduktStoritev NewAccount =
                                ProduktStoritev.fromJson(valueMap);
                            PS.add(NewAccount);
                          }

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

                          if (isChecked == false) {
                            int indexBanka = banke.indexWhere(
                                (element) => element.ime == placilo);

                            for (int l = 0; l < prodaje.length; l++) {
                              banke[indexBanka].transakcije.add(jsonEncode(
                                  Transakcija(
                                      ID: uuid.v1(),
                                      opis: '',
                                      datum: kontDate.toString(),
                                      kont: placilo,
                                      prejemnikPlacila: dobavitelj,
                                      prejeto: prodaje[l].vsota as String,
                                      placilo: '')));
                            }
                            String oldStanje = banke[indexBanka].bilanca;
                            double newDouble = double.parse(oldStanje) +
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

                            int strankaIndex = stranke.indexWhere(
                                (element) => element.naziv == dobavitelj);

                            Stranka oldStranka = stranke[strankaIndex];
                            for (int ll = 0; ll < prodaje.length; ll++) {
                              oldStranka.transakcije.add(jsonEncode(Transakcija(
                                  ID: uuid.v1(),
                                  opis: '',
                                  datum: kontDate.toString(),
                                  kont: placilo,
                                  prejemnikPlacila: dobavitelj,
                                  prejeto: prodaje[ll].vsota as String,
                                  placilo: '')));
                            }

                            stranke[strankaIndex] = Stranka(
                                ID: oldStranka.ID,
                                naziv: oldStranka.naziv,
                                naslov: oldStranka.naslov,
                                tel: oldStranka.tel,
                                email: oldStranka.email,
                                bilanca: (double.parse(oldStranka.bilanca) +
                                        double.parse(skupnaVrednost))
                                    .toString(),
                                transakcije: oldStranka.transakcije);

                            //kreditiraj prihodke in debitiraj kartico, povečaj
                            //produkte in storitve zmanjšaj če je inventar
                            int kontBankaIndex = konti.indexWhere(
                                (element) => element.ime == placilo);

                            Kont oldBankaKont = konti[kontBankaIndex];
                            double oldBankaBalance =
                                double.parse(oldBankaKont.bilanca);
                            double newBankaBalance =
                                double.parse(skupnaVrednost);

                            String newBilancaString =
                                (oldBankaBalance + newBankaBalance).toString();

                            konti[kontBankaIndex] = Kont(
                                ID: oldBankaKont.ID,
                                ime: oldBankaKont.ime,
                                tip: oldBankaKont.tip,
                                podtip: oldBankaKont.podtip,
                                bilanca: newBilancaString,
                                amortizacija: oldBankaKont.amortizacija,
                                bilancaDate: oldBankaKont.bilancaDate,
                                amortizacijaDate: oldBankaKont.amortizacijaDate,
                                debet: (double.parse(oldBankaKont.debet) +
                                        double.parse(skupnaVrednost))
                                    .toString(),
                                kredit: oldBankaKont.kredit);

                            for (int n = 0; n < prodaje.length; n++) {
                              String imeKontaStroska = prodaje[n].kont;
                              int indexKonta = konti.indexWhere(
                                  (element) => element.ime == imeKontaStroska);
                              Kont oldInventarKont = konti[indexKonta];

                              double vsota =
                                  double.parse(prodaje[n].vsota as String);
                              double ddv =
                                  double.parse(prodaje[n].DDV as String);
                              double cena =
                                  double.parse(prodaje[n].cena as String);
                              double kolicina =
                                  double.parse(prodaje[n].kolicina as String);

                              double vsotaProdaje = kolicina * cena;

                              double vsotaDavka =
                                  ((ddv / 100) * cena) * kolicina;

                              konti[indexKonta] = Kont(
                                  ID: oldInventarKont.ID,
                                  ime: oldInventarKont.ime,
                                  tip: oldInventarKont.tip,
                                  podtip: oldInventarKont.podtip,
                                  bilanca:
                                      (double.parse(oldInventarKont.bilanca) -
                                              vsotaProdaje)
                                          .toString(),
                                  amortizacija: oldInventarKont.amortizacija,
                                  bilancaDate: oldInventarKont.bilancaDate,
                                  amortizacijaDate:
                                      oldInventarKont.amortizacijaDate,
                                  kredit:
                                      (double.parse(oldInventarKont.kredit) +
                                              vsotaProdaje)
                                          .toString(),
                                  debet: oldInventarKont.debet);

                              //vnosi v dnevnik
                              vnosiJson.add(jsonEncode(VnosVDnevnik(
                                  datum: kontDate.toString(),
                                  debet: vsotaProdaje.toString(),
                                  kredit: vsotaProdaje.toString(),
                                  kontDebet: placilo,
                                  kontKredit: prodaje[n].kont,
                                  komentar: '',
                                  id: uuid.v1())));

                              int indexKontaDavki = konti.indexWhere(
                                  (element) => element.ime == kontDavki);
                              Kont oldDavki = konti[indexKontaDavki];
                              konti[indexKontaDavki] = Kont(
                                  ID: oldDavki.ID,
                                  ime: oldDavki.ime,
                                  tip: oldDavki.tip,
                                  podtip: oldDavki.podtip,
                                  bilanca: (double.parse(oldDavki.bilanca) -
                                          vsotaDavka)
                                      .toString(),
                                  amortizacija: oldDavki.amortizacija,
                                  bilancaDate: oldDavki.bilancaDate,
                                  amortizacijaDate: oldDavki.amortizacijaDate,
                                  debet: oldDavki.debet,
                                  kredit: (double.parse(oldDavki.kredit) +
                                          vsotaDavka)
                                      .toString());

                              vnosiJson.add(jsonEncode(VnosVDnevnik(
                                  datum: kontDate.toString(),
                                  debet: vsotaDavka.toString(),
                                  kredit: vsotaDavka.toString(),
                                  kontDebet: placilo,
                                  kontKredit: kontDavki,
                                  komentar: '',
                                  id: uuid.v1())));

                              if (prodaje[n].tip == 'produkt') {
                                /////////////////////////////////////////////

                                Prodaja prodaja = prodaje[n];

                                int index = predmeti.indexWhere(
                                    (element) => element.ime == prodaja.PS);
                                Predmet oldd = predmeti[index];
                                double kolicinaOldd =
                                    double.parse(oldd.kolicina);
                                double bilancaOldd = double.parse(oldd.bilanca);
                                double potrebnaKolicina =
                                    double.parse(prodaja.kolicina as String);
                                double vrednostEne = bilancaOldd / kolicinaOldd;
                                double odstejVrednost =
                                    potrebnaKolicina * vrednostEne;
                                /*double novaKolicina =
                                kolicinaOld - potrebnaKolicina;
                            double novaBilanca = bilancaOld - odstejVrednost;
                            skupnabilanca += odstejVrednost;*/
                                Strosek strosek = Strosek(
                                    ID: ID,
                                    IS: 'IS',
                                    produkt: 'produkt',
                                    kolicina: 'kolicina',
                                    kont: 'kont',
                                    cena: 'cena');
                                for (int i = 0; i < stroski.length; i++) {
                                  List<dynamic> s = stroski[i].stroski;
                                  List<Strosek> st = [];

                                  for (int j = 0; j < s.length; j++) {
                                    Map<String, dynamic> valueMap =
                                        json.decode(s[j]);
                                    st.add(Strosek.fromJson(valueMap));
                                  }
                                  int indexx = st.indexWhere((element) =>
                                      element.produkt == prodaja.PS);
                                  if (indexx == -1) {
                                    continue;
                                  } else {
                                    strosek = st[indexx];
                                  }
                                }

                                int kotnIndex = konti.indexWhere(
                                    (element) => element.ime == oldd.kont);
                                Kont oldk = konti[kotnIndex];
                                konti[kotnIndex] = Kont(
                                  ID: oldk.ID,
                                  ime: oldk.ime,
                                  tip: oldk.tip,
                                  podtip: oldk.podtip,
                                  bilanca: (double.parse(oldk.bilanca) -
                                          odstejVrednost)
                                      .toStringAsFixed(2),
                                  amortizacija: oldk.amortizacija,
                                  bilancaDate: oldk.bilancaDate,
                                  amortizacijaDate: oldk.amortizacijaDate,
                                  debet: oldk.debet,
                                  kredit: (double.parse(oldk.kredit) +
                                          odstejVrednost)
                                      .toStringAsFixed(2),
                                );

                                int kontIndex = konti.indexWhere(
                                    (element) => element.ime == kontPlaniranja);

                                Kont oldKont = konti[kontIndex];
                                var uuid = Uuid();

                                konti[kontIndex] = Kont(
                                    ID: oldKont.ID,
                                    ime: oldKont.ime,
                                    tip: oldKont.tip,
                                    podtip: oldKont.podtip,
                                    bilanca: (double.parse(oldKont.bilanca) +
                                            odstejVrednost)
                                        .toStringAsFixed(2),
                                    amortizacija: oldKont.amortizacija,
                                    bilancaDate: oldKont.bilancaDate,
                                    amortizacijaDate: oldKont.amortizacijaDate,
                                    debet: (double.parse(oldKont.debet) +
                                            odstejVrednost)
                                        .toStringAsFixed(2),
                                    kredit: oldKont.kredit);

                                //dodaj vnos za stroske prodaje
                                vnosiJson.add(jsonEncode(VnosVDnevnik(
                                    datum: kontDate.toString(),
                                    debet: odstejVrednost.toString(),
                                    kredit: odstejVrednost.toString(),
                                    kontDebet: oldKont.ime,
                                    kontKredit: oldk.ime,
                                    komentar: '',
                                    id: uuid.v1())));
                                /////////////////////////

                                int inventarIndex = predmeti.indexWhere(
                                    (element) => element.ime == prodaje[n].PS);
                                double kolicina = double.parse(
                                        predmeti[inventarIndex].kolicina) -
                                    double.parse(prodaje[n].kolicina as String);
                                Predmet old = predmeti[inventarIndex];
                                double kolicinaOld = double.parse(old.kolicina);
                                double bilancaOld = double.parse(old.bilanca);
                                double ulomek1 = kolicinaOld / bilancaOld;
                                double bilancaNew = kolicina / ulomek1;
                                predmeti[inventarIndex] = Predmet(
                                    ID: old.ID,
                                    ime: old.ime,
                                    kolicina: kolicina.toString(),
                                    enota: old.enota,
                                    slika: old.slika,
                                    bilanca: bilancaNew.toString(),
                                    tip: old.tip,
                                    kont: old.kont);

                                int psIndex = PS.indexWhere((element) =>
                                    element.naziv == prodaje[n].PS);
                                ProduktStoritev oldps = PS[psIndex];
                                PS[psIndex] = ProduktStoritev(
                                    ID: oldps.ID,
                                    PS: oldps.PS,
                                    naziv: oldps.naziv,
                                    cena: oldps.cena,
                                    prodaja: (double.parse(oldps.prodaja) +
                                            double.parse(
                                                prodaje[n].kolicina as String))
                                        .toString(),
                                    bilanca: (double.parse(oldps.bilanca) +
                                            double.parse(
                                                prodaje[n].vsota as String))
                                        .toString());
                              } else {
                                int psIndex = PS.indexWhere((element) =>
                                    element.naziv == prodaje[n].PS);
                                ProduktStoritev oldps = PS[psIndex];
                                PS[psIndex] = ProduktStoritev(
                                    ID: oldps.ID,
                                    PS: oldps.PS,
                                    naziv: oldps.naziv,
                                    cena: oldps.cena,
                                    prodaja: (double.parse(oldps.prodaja) +
                                            double.parse(
                                                prodaje[n].kolicina as String))
                                        .toString(),
                                    bilanca: (double.parse(oldps.bilanca) +
                                            double.parse(
                                                prodaje[n].vsota as String))
                                        .toString());
                              }
                              List<String> predmettiJson = [];
                              List<String> storittveJson = [];
                              List<String> storiitveJson = [];
                              List<String> PSSJson = [];
                              for (int nn = 0; nn < PS.length; nn++) {
                                PSSJson.add(jsonEncode(PS[nn]));
                              }
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
                              List<String> StrankeJjson = [];
                              for (int z = 0; z < stranke.length; z++) {
                                StrankeJjson.add(jsonEncode(stranke[z]));
                              }
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(ID)
                                  .update({'stranke': StrankeJjson});
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(ID)
                                  .update({'produkti in storitve': PSSJson});
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
                          } else {
                            //kreditiraj prihodke in debitiraj terjatve
                            //spremeni produkte/storitve in inventar
                            int kontTerjatevIndex = konti.indexWhere(
                                (element) => element.ime == obveznost);

                            Kont oldTerjatev = konti[kontTerjatevIndex];
                            konti[kontTerjatevIndex] = Kont(
                                ID: oldTerjatev.ID,
                                ime: oldTerjatev.ime,
                                tip: oldTerjatev.tip,
                                podtip: oldTerjatev.podtip,
                                bilanca: (double.parse(oldTerjatev.bilanca) +
                                        double.parse(skupnaVrednost))
                                    .toString(),
                                amortizacija: oldTerjatev.amortizacija,
                                bilancaDate: oldTerjatev.bilancaDate,
                                amortizacijaDate: oldTerjatev.amortizacijaDate,
                                debet: (double.parse(oldTerjatev.debet) +
                                        double.parse(skupnaVrednost))
                                    .toString(),
                                kredit: oldTerjatev.kredit);

                            for (int n = 0; n < prodaje.length; n++) {
                              String imeKontaStroska = prodaje[n].kont;
                              int indexKonta = konti.indexWhere(
                                  (element) => element.ime == imeKontaStroska);
                              Kont oldInventarKont = konti[indexKonta];

                              double vsota =
                                  double.parse(prodaje[n].vsota as String);
                              double ddv =
                                  double.parse(prodaje[n].DDV as String);
                              double cena =
                                  double.parse(prodaje[n].cena as String);
                              double kolicina =
                                  double.parse(prodaje[n].kolicina as String);

                              double vsotaProdaje = kolicina * cena;

                              double vsotaDavka =
                                  ((ddv / 100) * cena) * kolicina;

                              konti[indexKonta] = Kont(
                                  ID: oldInventarKont.ID,
                                  ime: oldInventarKont.ime,
                                  tip: oldInventarKont.tip,
                                  podtip: oldInventarKont.podtip,
                                  bilanca:
                                      (double.parse(oldInventarKont.bilanca) -
                                              vsotaProdaje)
                                          .toString(),
                                  amortizacija: oldInventarKont.amortizacija,
                                  bilancaDate: oldInventarKont.bilancaDate,
                                  amortizacijaDate:
                                      oldInventarKont.amortizacijaDate,
                                  kredit:
                                      (double.parse(oldInventarKont.kredit) +
                                              vsotaProdaje)
                                          .toString(),
                                  debet: oldInventarKont.debet);

                              //vnosi v dnevnik
                              vnosiJson.add(jsonEncode(VnosVDnevnik(
                                  datum: kontDate.toString(),
                                  debet: prodaje[n].vsota as String,
                                  kredit: prodaje[n].vsota as String,
                                  kontDebet: obveznost,
                                  kontKredit: prodaje[n].kont,
                                  komentar: '',
                                  id: uuid.v1())));

                              int indexKontaDavki = konti.indexWhere(
                                  (element) => element.ime == kontDavki);
                              Kont oldDavki = konti[indexKontaDavki];
                              konti[indexKontaDavki] = Kont(
                                  ID: oldDavki.ID,
                                  ime: oldDavki.ime,
                                  tip: oldDavki.tip,
                                  podtip: oldDavki.podtip,
                                  bilanca: (double.parse(oldDavki.bilanca) -
                                          vsotaDavka)
                                      .toString(),
                                  amortizacija: oldDavki.amortizacija,
                                  bilancaDate: oldDavki.bilancaDate,
                                  amortizacijaDate: oldDavki.amortizacijaDate,
                                  debet: oldDavki.debet,
                                  kredit: (double.parse(oldDavki.kredit) +
                                          vsotaDavka)
                                      .toString());

                              if (prodaje[n].tip == 'produkt') {
                                //////////////////////////////////
                                Prodaja prodaja = prodaje[n];

                                int index = predmeti.indexWhere(
                                    (element) => element.ime == prodaja.PS);
                                Predmet oldd = predmeti[index];
                                double kolicinaOldd =
                                    double.parse(oldd.kolicina);
                                double bilancaOldd = double.parse(oldd.bilanca);
                                double potrebnaKolicina =
                                    double.parse(prodaja.kolicina as String);
                                double vrednostEne = bilancaOldd / kolicinaOldd;
                                double odstejVrednost =
                                    potrebnaKolicina * vrednostEne;
                                /*double novaKolicina =
                                kolicinaOld - potrebnaKolicina;
                            double novaBilanca = bilancaOld - odstejVrednost;
                            skupnabilanca += odstejVrednost;*/
                                Strosek strosek = Strosek(
                                    ID: ID,
                                    IS: 'IS',
                                    produkt: 'produkt',
                                    kolicina: 'kolicina',
                                    kont: 'kont',
                                    cena: 'cena');
                                for (int i = 0; i < stroski.length; i++) {
                                  List<dynamic> s = stroski[i].stroski;
                                  List<Strosek> st = [];

                                  for (int j = 0; j < s.length; j++) {
                                    Map<String, dynamic> valueMap =
                                        json.decode(s[j]);
                                    st.add(Strosek.fromJson(valueMap));
                                  }
                                  int indexx = st.indexWhere((element) =>
                                      element.produkt == prodaja.PS);
                                  if (indexx == -1) {
                                    continue;
                                  } else {
                                    strosek = st[indexx];
                                  }
                                }

                                int kotnIndex = konti.indexWhere(
                                    (element) => element.ime == oldd.kont);
                                Kont oldk = konti[kotnIndex];
                                konti[kotnIndex] = Kont(
                                  ID: oldk.ID,
                                  ime: oldk.ime,
                                  tip: oldk.tip,
                                  podtip: oldk.podtip,
                                  bilanca: (double.parse(oldk.bilanca) -
                                          odstejVrednost)
                                      .toStringAsFixed(2),
                                  amortizacija: oldk.amortizacija,
                                  bilancaDate: oldk.bilancaDate,
                                  amortizacijaDate: oldk.amortizacijaDate,
                                  debet: oldk.debet,
                                  kredit: (double.parse(oldk.kredit) +
                                          odstejVrednost)
                                      .toStringAsFixed(2),
                                );

                                int kontIndex = konti.indexWhere(
                                    (element) => element.ime == kontPlaniranja);

                                Kont oldKont = konti[kontIndex];
                                var uuid = Uuid();

                                konti[kontIndex] = Kont(
                                    ID: oldKont.ID,
                                    ime: oldKont.ime,
                                    tip: oldKont.tip,
                                    podtip: oldKont.podtip,
                                    bilanca: (double.parse(oldKont.bilanca) +
                                            odstejVrednost)
                                        .toStringAsFixed(2),
                                    amortizacija: oldKont.amortizacija,
                                    bilancaDate: oldKont.bilancaDate,
                                    amortizacijaDate: oldKont.amortizacijaDate,
                                    debet: (double.parse(oldKont.debet) +
                                            odstejVrednost)
                                        .toStringAsFixed(2),
                                    kredit: oldKont.kredit);

                                //dodaj vnos za stroske prodaje
                                vnosiJson.add(jsonEncode(VnosVDnevnik(
                                    datum: kontDate.toString(),
                                    debet: odstejVrednost.toString(),
                                    kredit: odstejVrednost.toString(),
                                    kontDebet: oldKont.ime,
                                    kontKredit: oldk.ime,
                                    komentar: '',
                                    id: uuid.v1())));
                                //////////////////////
                                int inventarIndex = predmeti.indexWhere(
                                    (element) => element.ime == prodaje[n].PS);
                                double kolicina = double.parse(
                                        predmeti[inventarIndex].kolicina) -
                                    double.parse(prodaje[n].kolicina as String);
                                Predmet old = predmeti[inventarIndex];
                                double kolicinaOld = double.parse(old.kolicina);
                                double bilancaOld = double.parse(old.bilanca);
                                double ulomek1 = kolicinaOld / bilancaOld;
                                double bilancaNew = kolicina / ulomek1;
                                predmeti[inventarIndex] = Predmet(
                                    ID: old.ID,
                                    ime: old.ime,
                                    kolicina: kolicina.toString(),
                                    enota: old.enota,
                                    slika: old.slika,
                                    bilanca: bilancaNew.toString(),
                                    tip: old.tip,
                                    kont: old.kont);

                                int psIndex = PS.indexWhere((element) =>
                                    element.naziv == prodaje[n].PS);
                                ProduktStoritev oldps = PS[psIndex];
                                PS[psIndex] = ProduktStoritev(
                                    ID: oldps.ID,
                                    PS: oldps.PS,
                                    naziv: oldps.naziv,
                                    cena: oldps.cena,
                                    prodaja: (double.parse(oldps.prodaja) +
                                            double.parse(
                                                prodaje[n].kolicina as String))
                                        .toString(),
                                    bilanca: (double.parse(oldps.bilanca) +
                                            double.parse(
                                                prodaje[n].vsota as String))
                                        .toString());
                              } else {
                                int psIndex = PS.indexWhere((element) =>
                                    element.naziv == prodaje[n].PS);
                                ProduktStoritev oldps = PS[psIndex];
                                PS[psIndex] = ProduktStoritev(
                                    ID: oldps.ID,
                                    PS: oldps.PS,
                                    naziv: oldps.naziv,
                                    cena: oldps.cena,
                                    prodaja: (double.parse(oldps.prodaja) +
                                            double.parse(
                                                prodaje[n].kolicina as String))
                                        .toString(),
                                    bilanca: (double.parse(oldps.bilanca) +
                                            double.parse(
                                                prodaje[n].vsota as String))
                                        .toString());
                              }
                            }

                            List<String> predmettiJson = [];
                            List<String> storittveJson = [];
                            List<String> storiitveJson = [];
                            List<String> PSSJson = [];
                            for (int nn = 0; nn < PS.length; nn++) {
                              PSSJson.add(jsonEncode(PS[nn]));
                            }
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
                            List<String> StrankeJjson = [];
                            for (int z = 0; z < stranke.length; z++) {
                              StrankeJjson.add(jsonEncode(stranke[z]));
                            }
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'stranke': StrankeJjson});
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(ID)
                                .update({'produkti in storitve': PSSJson});
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

                          //generiraj pdf
                          Invoice invoice = Invoice(
                              ID: uuid.v1(),
                              racun: novaProdaja,
                              stranka: stranka,
                              izdajateljIme: imeProdajalca,
                              izdajateljPodjetje: firmaProdajalca,
                              sedezPodjetja: naslovPodjetja);
                          Storage storage = Storage();

                          await storage.getData(
                              'users',
                              box.get('email') +
                                  '/images/' +
                                  '_Logotip' +
                                  '.png');

                          final pdfFile = await PdfInvoiceApi.generate(
                              invoice, storage.downloadURL as String);

                          path = await box.get('data');
                          int i = 0;

                          //Storage storage = Storage();
                          final url = await storage.UploadFileMobilePdf(
                              path, 'name', box.get('email'));
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PdfViewerPage(url: url),
                            ),
                          );
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

String path = '';

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfPdfViewer.network(
      path,
    ));
  }
}

void _openNewScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NewScreen(),
    ),
  );
}

class PdfViewerPage extends StatelessWidget {
  final String url;

  const PdfViewerPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: SfPdfViewer.network(
        url,
        canShowScrollHead: false,
      ),
    );
  }
}
