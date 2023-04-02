import 'dart:convert';

import 'package:accounting_app/objekti/strosek.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:uuid/uuid.dart';

import '../../data/data.dart';
import '../../objekti/banka.dart';
import '../../objekti/dobavitelj.dart';
import '../../objekti/kont.dart';
import '../../objekti/predmet.dart';
import '../../objekti/racun_strosek.dart';
import '../../objekti/storitev.dart';
import '../../objekti/transakcija.dart';
import '../../objekti/vnos_v_dnevnik.dart';

class PlacajRacun extends StatefulWidget {
  const PlacajRacun({super.key, required this.rc});
  final RacunStrosek rc;

  @override
  State<PlacajRacun> createState() => _PlacajRacunState();
}

class _PlacajRacunState extends State<PlacajRacun> {
  Color color = Color.fromRGBO(255, 231, 230, 1);
  int _enterCounter = 0;
  int _exitCounter = 0;
  double x = 0.0;
  double y = 0.0;

  void _incrementEnter(PointerEvent details) {
    setState(() {
      _enterCounter++;
    });
  }

  void _incrementExit(PointerEvent details) {
    setState(() {
      color = Color.fromRGBO(255, 231, 230, 1);
      _exitCounter++;
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      color = Color.fromRGBO(231, 255, 230, 1);
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //naredi placan true
        //kreditiraj banko in debitiraj obveznosti
        //dodaj transakcijo dobavitelju
        var db = FirebaseFirestore.instance;
        String ID = box.get('email');
        final docRef = db.collection("Users").doc(ID);
        docRef.get().then((DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          List<dynamic> stroskiJson = data['stroski'];
          List<RacunStrosek> stroski = [];

          for (int i = 0; i < stroskiJson.length; i++) {
            Map<String, dynamic> valueMap = json.decode(stroskiJson[i]);
            RacunStrosek NewAccount = RacunStrosek.fromJson(valueMap);
            stroski.add(NewAccount);
          }
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
            Map<String, dynamic> valueMap = json.decode(bankaJson[j]);
            Banka NewAccount = Banka.fromJson(valueMap);
            banke.add(NewAccount);
          }

          for (int jj = 0; jj < dobaviteljiJson.length; jj++) {
            Map<String, dynamic> valueMap = json.decode(dobaviteljiJson[jj]);
            Dobavitelj NewAccount = Dobavitelj.fromJson(valueMap);
            dobavitelji.add(NewAccount);
          }

          for (int s = 0; s < storitveJson.length; s++) {
            Map<String, dynamic> valueMap = json.decode(storitveJson[s]);
            Storitev NewAccount = Storitev.fromJson(valueMap);
            storitve.add(NewAccount);
          }

          for (int t = 0; t < predmetiJson.length; t++) {
            Map<String, dynamic> valueMap = json.decode(predmetiJson[t]);
            Predmet NewAccount = Predmet.fromJson(valueMap);
            predmeti.add(NewAccount);
          }

          for (int k = 0; k < kontiJson.length; k++) {
            Map<String, dynamic> valueMap = json.decode(kontiJson[k]);
            Kont NewAccount = Kont.fromJson(valueMap);
            konti.add(NewAccount);
          }

          for (int o = 0; o < vnosiJson.length; o++) {
            Map<String, dynamic> valueMap = json.decode(vnosiJson[o]);
            VnosVDnevnik NewAccount = VnosVDnevnik.fromJson(valueMap);
            vnosi.add(NewAccount);
          }

          //placan je true
          int stroskiIndex =
              stroski.indexWhere((element) => element.ID == widget.rc.ID);
          RacunStrosek strosekOld = stroski[stroskiIndex];
          stroski[stroskiIndex] = RacunStrosek(
              ID: strosekOld.ID,
              dobavitelj: strosekOld.dobavitelj,
              kontPlacila: strosekOld.kontPlacila,
              datum: strosekOld.datum,
              stroski: strosekOld.stroski,
              bilanca: strosekOld.bilanca,
              placan: true,
              rokPlacila: strosekOld.rokPlacila,
              kontObveznost: strosekOld.kontObveznost);

          //kreditiraj banko in debitiraj obveznosti
          //dodaj transakcijo dobavitelju
          var uuid = Uuid();
          int indexBanka = banke
              .indexWhere((element) => element.ime == strosekOld.kontPlacila);

          for (int l = 0; l < strosekOld.stroski.length; l++) {
            Map<String, dynamic> valueMap = json.decode(strosekOld.stroski[l]);

            Strosek stt = Strosek.fromJson(valueMap);
            banke[indexBanka].transakcije.add(jsonEncode(Transakcija(
                ID: uuid.v1(),
                opis: '',
                datum: strosekOld.datum,
                kont:
                    stt.kont as String, //strosekOld.stroski[l].kont as String,
                prejemnikPlacila: strosekOld.dobavitelj,
                prejeto: '',
                placilo: stt.cena)));
          }

          String oldStanje = banke[indexBanka].bilanca;
          double newDouble =
              double.parse(oldStanje) - double.parse(strosekOld.bilanca);
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

          int dobaviteljIndex = dobavitelji
              .indexWhere((element) => element.naziv == strosekOld.dobavitelj);
          Dobavitelj dobaviteljOld = dobavitelji[dobaviteljIndex];
          for (int ll = 0; ll < strosekOld.stroski.length; ll++) {
            Map<String, dynamic> valueMap = json.decode(strosekOld.stroski[ll]);
            Strosek stt = Strosek.fromJson(valueMap);

            dobaviteljOld.transakcije.add(jsonEncode(Transakcija(
                ID: uuid.v1(),
                opis: '',
                datum: strosekOld.datum,
                kont: stt.kont as String,
                prejemnikPlacila: strosekOld.dobavitelj,
                prejeto: '',
                placilo: stt.cena)));
          }
          dobavitelji[dobaviteljIndex] = Dobavitelj(
              ID: dobaviteljOld.ID,
              naziv: dobaviteljOld.naziv,
              naslov: dobaviteljOld.naslov,
              tel: dobaviteljOld.tel,
              email: dobaviteljOld.email,
              bilanca: (double.parse(dobaviteljOld.bilanca) +
                      double.parse(strosekOld.bilanca))
                  .toString(),
              transakcije: dobaviteljOld.transakcije);

          int kontBankaIndex = konti
              .indexWhere((element) => element.ime == strosekOld.kontPlacila);

          Kont oldBankaKont = konti[kontBankaIndex];
          double oldBankaBalance = double.parse(oldBankaKont.bilanca);
          double newBankaBalance = double.parse(strosekOld.bilanca);

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
                      double.parse(strosekOld.bilanca))
                  .toString());

          int kontObveznostIndex = konti
              .indexWhere((element) => element.ime == strosekOld.kontObveznost);
          Kont oldObveznost = konti[kontObveznostIndex];
          konti[kontObveznostIndex] = Kont(
              ID: oldObveznost.ID,
              ime: oldObveznost.ime,
              tip: oldObveznost.tip,
              podtip: oldObveznost.podtip,
              bilanca: (double.parse(oldObveznost.bilanca) +
                      double.parse(strosekOld.bilanca))
                  .toString(),
              amortizacija: oldObveznost.amortizacija,
              bilancaDate: oldObveznost.bilancaDate,
              amortizacijaDate: oldObveznost.amortizacijaDate,
              debet: (double.parse(oldObveznost.debet) +
                      double.parse(strosekOld.bilanca))
                  .toString(),
              kredit: oldObveznost.kredit);

          for (int n = 0; n < strosekOld.stroski.length; n++) {
            Map<String, dynamic> valueMap = json.decode(strosekOld.stroski[n]);

            Strosek str = Strosek.fromJson(valueMap);
            vnosiJson.add(jsonEncode(VnosVDnevnik(
                datum: DateTime.now().toString(),
                debet: str.cena,
                kredit: str.cena,
                kontDebet: strosekOld.kontObveznost,
                kontKredit: strosekOld.kontPlacila,
                komentar: '',
                id: uuid.v1())));
          }

          List<String> kontiJsonn = [];
          for (int p = 0; p < konti.length; p++) {
            kontiJsonn.add(jsonEncode(konti[p]));
          }

          List<String> dobaviteljiJsonn = [];
          for (int pp = 0; pp < dobavitelji.length; pp++) {
            dobaviteljiJsonn.add(jsonEncode(dobavitelji[pp]));
          }

          List<String> stroskiJsonn = [];
          for (int pp = 0; pp < stroski.length; pp++) {
            stroskiJsonn.add(jsonEncode(stroski[pp]));
          }
          FirebaseFirestore.instance
              .collection('Users')
              .doc(ID)
              .update({'stroski': stroskiJsonn});
          FirebaseFirestore.instance
              .collection('Users')
              .doc(ID)
              .update({'dobavitelji': dobaviteljiJsonn});

          FirebaseFirestore.instance
              .collection('Users')
              .doc(ID)
              .update({'konti': kontiJsonn});
          FirebaseFirestore.instance
              .collection('Users')
              .doc(ID)
              .update({'vnosi v dnevnik': vnosiJson});
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: _incrementEnter,
        onHover: _updateLocation,
        onExit: _incrementExit,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: ImageIcon(
            AssetImage('lib/sredstva/check.png'),
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
