import 'dart:convert';

import 'package:accounting_app/objekti/racun_strosek.dart';
import 'package:accounting_app/objekti/strosek.dart';
import 'package:accounting_app/objekti/vnos_v_dnevnik.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:uuid/uuid.dart';

import '../../data/data.dart';
import '../../objekti/kont.dart';
import '../../objekti/material.dart';
import '../../objekti/plan.dart';
import '../../objekti/predmet.dart';
import '../../objekti/projekt.dart';
import '../../services/storage_service.dart';

class PlanCard extends StatefulWidget {
  const PlanCard({super.key, required this.plan});
  final Plan plan;

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  Storage storage = Storage();
  late String image;
  late String data;
  late String ID;
  late String path;
  @override
  void initState() {
    ID = box.get('email');
    path = box.get('email') + '/images/' + widget.plan.ime + '.png';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        width: 300,
        height: 400,
        decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xEEEEEEEE),
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: [
            Container(
              width: 290,
              height: 290,
              child: FutureBuilder(
                future: storage.getData('users',
                    box.get('email') + '/images/' + widget.plan.ime + '.png'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      "Something went wrong",
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      width: 290,
                      height: 290,
                      child: Image.network(
                        fit: BoxFit.cover,
                        snapshot.data.toString(),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Container(
              height: 30,
              child: Text(
                widget.plan.ime,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 120, height: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      //preveri ali je izdelava možna
                      //izdelaj, dodaj +1 v inventar
                      //znizaj sestavine in njihove bilance
                      var db = FirebaseFirestore.instance;
                      String ID = box.get('email');
                      final docRef = db.collection("Users").doc(ID);
                      docRef.get().then((DocumentSnapshot doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        List<Predmet> predmeti = [];
                        List<Projekt> projekti = [];
                        List<Materiall> materials = [];
                        List<Plan> planiraneStoritve = [];
                        List<Kont> konti = [];
                        List<RacunStrosek> stroski = [];
                        List<VnosVDnevnik> vnosi = [];
                        List<dynamic> predmetiJson = data['predmeti'];
                        List<dynamic> projektiJson = data['projekti'];
                        List<dynamic> planJson = data['planirane storitve'];
                        List<dynamic> kontiJson = data['konti'];
                        List<dynamic> stroskiJson = data['stroski'];
                        List<dynamic> vnosiJson = data['vnosi v dnevnik'];

                        for (int i = 0; i < predmetiJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(predmetiJson[i]);
                          Predmet NewAccount = Predmet.fromJson(valueMap);
                          predmeti.add(NewAccount);
                        }

                        for (int i = 0; i < vnosiJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(vnosiJson[i]);
                          VnosVDnevnik NewAccount =
                              VnosVDnevnik.fromJson(valueMap);
                          vnosi.add(NewAccount);
                        }

                        for (int i = 0; i < stroskiJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(stroskiJson[i]);
                          RacunStrosek NewAccount =
                              RacunStrosek.fromJson(valueMap);
                          stroski.add(NewAccount);
                        }

                        for (int i = 0; i < kontiJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(kontiJson[i]);
                          Kont NewAccount = Kont.fromJson(valueMap);
                          konti.add(NewAccount);
                        }

                        for (int j = 0; j < projektiJson.length; j++) {
                          Map<String, dynamic> valueMap =
                              json.decode(projektiJson[j]);
                          Projekt NewAccount = Projekt.fromJson(valueMap);
                          projekti.add(NewAccount);
                        }

                        for (int j = 0; j < planJson.length; j++) {
                          Map<String, dynamic> valueMap =
                              json.decode(planJson[j]);
                          Plan NewAccount = Plan.fromJson(valueMap);
                          planiraneStoritve.add(NewAccount);
                        }

                        int projektIndex = planiraneStoritve.indexWhere(
                            (element) => element.ID == widget.plan.ID);
                        Plan project = planiraneStoritve[projektIndex];

                        List<dynamic> materiali = project.material;
                        List<Materiall> materialiObj = [];
                        for (int k = 0; k < materiali.length; k++) {
                          Map<String, dynamic> valueMap =
                              json.decode(materiali[k]);

                          materialiObj.add(Materiall.fromJson(valueMap));
                        }

                        bool nemogoce = false;
                        for (int i = 0; i < materialiObj.length; i++) {
                          int index = predmeti.indexWhere(
                              (element) => element.ime == materialiObj[i].ime);
                          if (double.parse(predmeti[index].kolicina) <
                              double.parse(materialiObj[i].kolicina)) {
                            nemogoce = true;
                          }
                        }

                        if (nemogoce == true) {
                          AlertDialog alert = AlertDialog(
                            //title: Text("My title"),
                            content: Container(
                                height: 400,
                                width: 400,
                                child: Text(
                                    "Izdelava ni mogoča, ker nimate dovolj materiala.")),
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        } else {
                          double skupnabilanca = 0;
                          Strosek strosek = Strosek(
                              ID: ID,
                              IS: 'IS',
                              produkt: 'produkt',
                              kolicina: 'kolicina',
                              kont: 'kont',
                              cena: 'cena');

                          //odtrani iz inventarja
                          for (int i = 0; i < materialiObj.length; i++) {
                            int index = predmeti.indexWhere((element) =>
                                element.ime == materialiObj[i].ime);
                            Predmet old = predmeti[index];
                            double kolicinaOld = double.parse(old.kolicina);
                            double bilancaOld = double.parse(old.bilanca);
                            double potrebnaKolicina =
                                double.parse(materialiObj[i].kolicina);
                            double vrednostEne = bilancaOld / kolicinaOld;
                            double odstejVrednost =
                                potrebnaKolicina * vrednostEne;
                            double novaKolicina =
                                kolicinaOld - potrebnaKolicina;
                            double novaBilanca = bilancaOld - odstejVrednost;
                            skupnabilanca += odstejVrednost;

                            predmeti[index] = Predmet(
                                kont: old.kont,
                                ID: old.ID,
                                ime: old.ime,
                                kolicina: novaKolicina.toString(),
                                enota: old.enota,
                                slika: old.slika,
                                bilanca: novaBilanca.toStringAsFixed(2),
                                tip: old.tip);
                            bool found = false;
                            //išče kont inventarja
                            for (int i = 0; i < stroski.length; i++) {
                              List<dynamic> s = stroski[i].stroski;
                              List<Strosek> st = [];
                              for (int j = 0; j < s.length; j++) {
                                Map<String, dynamic> valueMap =
                                    json.decode(s[j]);
                                st.add(Strosek.fromJson(valueMap));
                              }
                              int indexx = st.indexWhere(
                                  (element) => element.produkt == old.ime);
                              if (indexx == -1) {
                                continue;
                              } else {
                                strosek = st[indexx];
                              }
                            }

                            int kotnIndex = konti.indexWhere(
                                (element) => element.ime == strosek.kont);
                            Kont oldk = konti[kotnIndex];
                            konti[kotnIndex] = Kont(
                              ID: oldk.ID,
                              ime: oldk.ime,
                              tip: oldk.tip,
                              podtip: oldk.podtip,
                              bilanca:
                                  (double.parse(oldk.bilanca) - odstejVrednost)
                                      .toStringAsFixed(2),
                              amortizacija: oldk.amortizacija,
                              bilancaDate: oldk.bilancaDate,
                              amortizacijaDate: oldk.amortizacijaDate,
                              debet: oldk.debet,
                              kredit:
                                  (double.parse(oldk.kredit) + odstejVrednost)
                                      .toStringAsFixed(2),
                            );

                            int kontIndex = konti.indexWhere(
                                (element) => element.ime == widget.plan.kont);

                            Kont oldKont = konti[kontIndex];
                            var uuid = Uuid();

                            vnosiJson.add(jsonEncode(VnosVDnevnik(
                                datum: DateTime.now().toString(),
                                debet: odstejVrednost.toStringAsFixed(2),
                                kredit: odstejVrednost.toStringAsFixed(2),
                                kontDebet: oldKont.ime,
                                kontKredit: oldk.ime,
                                komentar: '',
                                id: uuid.v1())));
                          }

                          /*int projektIndex = predmeti.indexWhere(
                              (element) => element.ime == widget.plan.ime);

                          Predmet oldProjekt = predmeti[projektIndex];
                          predmeti[projektIndex] = Predmet(
                              ID: oldProjekt.ID,
                              ime: oldProjekt.ime,
                              kolicina: (double.parse(oldProjekt.kolicina) + 1)
                                  .toString(),
                              enota: oldProjekt.enota,
                              slika: oldProjekt.slika,
                              bilanca: (double.parse(oldProjekt.bilanca) +
                                      skupnabilanca)
                                  .toString(),
                              tip: oldProjekt.tip);*/

                          int kontIndex = konti.indexWhere(
                              (element) => element.ime == widget.plan.kont);

                          Kont oldKont = konti[kontIndex];

                          konti[kontIndex] = Kont(
                              ID: oldKont.ID,
                              ime: oldKont.ime,
                              tip: oldKont.tip,
                              podtip: oldKont.podtip,
                              bilanca: (double.parse(oldKont.bilanca) +
                                      skupnabilanca)
                                  .toStringAsFixed(2),
                              amortizacija: oldKont.amortizacija,
                              bilancaDate: oldKont.bilancaDate,
                              amortizacijaDate: oldKont.amortizacijaDate,
                              debet:
                                  (double.parse(oldKont.debet) + skupnabilanca)
                                      .toStringAsFixed(2),
                              kredit: oldKont.kredit);

                          List<String> predmetiJJson = [];
                          for (int i = 0; i < predmeti.length; i++) {
                            predmetiJJson.add(jsonEncode(predmeti[i]));
                          }

                          List<String> kontiJJson = [];
                          for (int i = 0; i < konti.length; i++) {
                            kontiJJson.add(jsonEncode(konti[i]));
                          }

                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(ID)
                              .update({'predmeti': predmetiJJson});

                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(ID)
                              .update({'vnosi v dnevnik': vnosiJson});

                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(ID)
                              .update({'konti': kontiJJson});

                          AlertDialog alert = AlertDialog(
                            //title: Text("My title"),
                            content: Container(
                                height: 400,
                                width: 400,
                                child: Text("Izdelek izdelan.")),
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        }
                      });
                    },
                    child: Text('Izdelaj'),
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
                ),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 120, height: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      var db = FirebaseFirestore.instance;
                      String ID = box.get('email');
                      final docRef = db.collection("Users").doc(ID);
                      docRef.get().then((DocumentSnapshot doc) {
                        List<Plan> accounts = [];

                        final data = doc.data() as Map<String, dynamic>;
                        List<dynamic> accountsJson = data['planirane storitve'];
                        for (int i = 0; i < accountsJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(accountsJson[i]);
                          Plan NewAccount = Plan.fromJson(valueMap);
                          accounts.add(NewAccount);
                        }

                        accounts.removeWhere(
                            (element) => element.ID == widget.plan.ID);

                        List<String> kontiJson = [];
                        for (int i = 0; i < accounts.length; i++) {
                          kontiJson.add(jsonEncode(accounts[i]));
                        }
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(ID)
                            .update({'projekti': kontiJson});
                      });
                    },
                    child: Text('Odstrani'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(0)),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            color: Colors.white))),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
