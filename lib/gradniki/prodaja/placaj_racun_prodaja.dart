import 'dart:convert';

import 'package:accounting_app/objekti/prodaja.dart';
import 'package:accounting_app/objekti/racun_prodaja.dart';
import 'package:accounting_app/objekti/stranka.dart';
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
import '../../objekti/storitev.dart';
import '../../objekti/strosek.dart';
import '../../objekti/transakcija.dart';
import '../../objekti/vnos_v_dnevnik.dart';

class PlacajRacunProdaja extends StatefulWidget {
  const PlacajRacunProdaja({super.key, required this.rp});
  final RacunProdaja rp;

  @override
  State<PlacajRacunProdaja> createState() => _PlacajRacunProdajaState();
}

class _PlacajRacunProdajaState extends State<PlacajRacunProdaja> {
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
          List<dynamic> prodajeJson = data['prodaja'];
          List<RacunProdaja> prodaje = [];

          for (int i = 0; i < prodajeJson.length; i++) {
            Map<String, dynamic> valueMap = json.decode(prodajeJson[i]);
            RacunProdaja NewAccount = RacunProdaja.fromJson(valueMap);
            prodaje.add(NewAccount);
          }
          List<Kont> konti = [];
          List<Banka> banke = [];
          List<VnosVDnevnik> vnosi = [];
          List<Predmet> predmeti = [];
          List<Storitev> storitve = [];
          List<Stranka> stranke = [];
          List<dynamic> bankaJson = data['banka'];
          List<dynamic> kontiJson = data['konti'];
          List<dynamic> vnosiJson = data['vnosi v dnevnik'];
          List<dynamic> predmetiJson = data['predmeti'];
          List<dynamic> storitveJson = data['storitve'];
          List<dynamic> strankeJson = data['stranke'];

          for (int j = 0; j < bankaJson.length; j++) {
            Map<String, dynamic> valueMap = json.decode(bankaJson[j]);
            Banka NewAccount = Banka.fromJson(valueMap);
            banke.add(NewAccount);
          }

          for (int jj = 0; jj < strankeJson.length; jj++) {
            Map<String, dynamic> valueMap = json.decode(strankeJson[jj]);
            Stranka NewAccount = Stranka.fromJson(valueMap);
            stranke.add(NewAccount);
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

          int prodajaIndex =
              prodaje.indexWhere((element) => element.ID == widget.rp.ID);

          RacunProdaja prodajaOld = prodaje[prodajaIndex];
          prodaje[prodajaIndex] = RacunProdaja(
              ID: prodajaOld.ID,
              stranka: prodajaOld.stranka,
              kontprodaje: prodajaOld.kontprodaje,
              datum: prodajaOld.datum,
              prodaje: prodajaOld.prodaje,
              bilanca: prodajaOld.bilanca,
              placan: true,
              rokPlacila: prodajaOld.rokPlacila,
              kontterjatev: prodajaOld.kontterjatev);

          //kreditiraj banko in debitiraj terjatve
          //dodaj transakcijo dobavitelju
          var uuid = Uuid();
          int indexBanka = banke
              .indexWhere((element) => element.ime == prodajaOld.kontprodaje);

          double prejeto = 0;
          for (int l = 0; l < prodajaOld.prodaje.length; l++) {
            Map<String, dynamic> valueMap = json.decode(prodajaOld.prodaje[l]);

            Prodaja stt = Prodaja.fromJson(valueMap);
            prejeto += double.parse(stt.vsota as String);
            banke[indexBanka].transakcije.add(jsonEncode(Transakcija(
                ID: uuid.v1(),
                opis: '',
                datum: prodajaOld.datum,
                kont:
                    stt.kont as String, //strosekOld.stroski[l].kont as String,
                prejemnikPlacila: prodajaOld.stranka,
                prejeto: prejeto.toString(),
                placilo: '')));
          }

          String oldStanje = banke[indexBanka].bilanca;
          double newDouble =
              double.parse(oldStanje) + double.parse(prodajaOld.bilanca);
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

          int strankeIndex = stranke
              .indexWhere((element) => element.naziv == prodajaOld.stranka);

          Stranka strankaOld = stranke[strankeIndex];
          for (int ll = 0; ll < prodajaOld.prodaje.length; ll++) {
            Map<String, dynamic> valueMap = json.decode(prodajaOld.prodaje[ll]);
            Strosek stt = Strosek.fromJson(valueMap);

            strankaOld.transakcije.add(jsonEncode(Transakcija(
                ID: uuid.v1(),
                opis: '',
                datum: prodajaOld.datum,
                kont: stt.kont as String,
                prejemnikPlacila: prodajaOld.stranka,
                prejeto: '',
                placilo: stt.cena)));
          }

          stranke[strankeIndex] = Stranka(
              ID: strankaOld.ID,
              naziv: strankaOld.naziv,
              naslov: strankaOld.naslov,
              tel: strankaOld.tel,
              email: strankaOld.email,
              bilanca: (double.parse(strankaOld.bilanca) +
                      double.parse(prodajaOld.bilanca))
                  .toString(),
              transakcije: strankaOld.transakcije);

          int kontBankaIndex = konti
              .indexWhere((element) => element.ime == prodajaOld.kontprodaje);

          Kont oldBankaKont = konti[kontBankaIndex];
          double oldBankaBalance = double.parse(oldBankaKont.bilanca);
          double newBankaBalance = double.parse(prodajaOld.bilanca);

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
                      double.parse(prodajaOld.bilanca))
                  .toString(),
              kredit: oldBankaKont.kredit);

          int kontObveznostIndex = konti
              .indexWhere((element) => element.ime == prodajaOld.kontterjatev);
          Kont oldObveznost = konti[kontObveznostIndex];
          konti[kontObveznostIndex] = Kont(
              ID: oldObveznost.ID,
              ime: oldObveznost.ime,
              tip: oldObveznost.tip,
              podtip: oldObveznost.podtip,
              bilanca: (double.parse(oldObveznost.bilanca) -
                      double.parse(prodajaOld.bilanca))
                  .toString(),
              amortizacija: oldObveznost.amortizacija,
              bilancaDate: oldObveznost.bilancaDate,
              amortizacijaDate: oldObveznost.amortizacijaDate,
              debet: oldObveznost.debet,
              kredit: (double.parse(oldObveznost.kredit) +
                      double.parse(prodajaOld.bilanca))
                  .toString());

          for (int n = 0; n < prodajaOld.prodaje.length; n++) {
            Map<String, dynamic> valueMap = json.decode(prodajaOld.prodaje[n]);

            Prodaja str = Prodaja.fromJson(valueMap);
            vnosiJson.add(jsonEncode(VnosVDnevnik(
                datum: DateTime.now().toString(),
                debet: str.vsota as String,
                kredit: str.vsota as String,
                kontDebet: prodajaOld.kontterjatev,
                kontKredit: prodajaOld.kontprodaje,
                komentar: '',
                id: uuid.v1())));
          }
          List<String> kontiJsonn = [];
          for (int p = 0; p < konti.length; p++) {
            kontiJsonn.add(jsonEncode(konti[p]));
          }

          List<String> dobaviteljiJsonn = [];
          for (int pp = 0; pp < stranke.length; pp++) {
            dobaviteljiJsonn.add(jsonEncode(stranke[pp]));
          }

          List<String> stroskiJsonn = [];
          for (int pp = 0; pp < prodaje.length; pp++) {
            stroskiJsonn.add(jsonEncode(prodaje[pp]));
          }
          FirebaseFirestore.instance
              .collection('Users')
              .doc(ID)
              .update({'prodaja': stroskiJsonn});
          FirebaseFirestore.instance
              .collection('Users')
              .doc(ID)
              .update({'stranke': dobaviteljiJsonn});

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
