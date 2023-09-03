import 'dart:convert';

import 'package:accounting_app/objekti/predmet.dart';
import 'package:accounting_app/objekti/projekt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/material.dart';
import '../../services/storage_service.dart';

class ProjektCardMobile extends StatefulWidget {
  const ProjektCardMobile({super.key, required this.projekt});
  final Projekt projekt;

  @override
  State<ProjektCardMobile> createState() => _ProjektCardMobileState();
}

class _ProjektCardMobileState extends State<ProjektCardMobile> {
  Storage storage = Storage();
  late String image;
  late String data;
  late String ID;
  late String path;
  @override
  void initState() {
    ID = box.get('email');
    path = box.get('email') + '/images/' + widget.projekt.ime + '.png';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        width: 260,
        height: 350,
        decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xEEEEEEEE),
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: [
            Container(
              width: 240,
              height: 240,
              child: FutureBuilder(
                future: storage.getData(
                    'users',
                    box.get('email') +
                        '/images/' +
                        widget.projekt.ime +
                        '.png'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      "Something went wrong",
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      width: 240,
                      height: 240,
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
                widget.projekt.ime,
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
                      const BoxConstraints.tightFor(width: 100, height: 50),
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
                        List<dynamic> predmetiJson = data['predmeti'];
                        List<dynamic> projektiJson = data['projekti'];

                        for (int i = 0; i < predmetiJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(predmetiJson[i]);
                          Predmet NewAccount = Predmet.fromJson(valueMap);
                          predmeti.add(NewAccount);
                        }

                        for (int j = 0; j < projektiJson.length; j++) {
                          Map<String, dynamic> valueMap =
                              json.decode(projektiJson[j]);
                          Projekt NewAccount = Projekt.fromJson(valueMap);
                          projekti.add(NewAccount);
                        }

                        int projektIndex = projekti.indexWhere(
                            (element) => element.ID == widget.projekt.ID);
                        Projekt project = projekti[projektIndex];
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
                                bilanca: novaBilanca.toString(),
                                tip: old.tip);
                          }

                          int projektIndex = predmeti.indexWhere(
                              (element) => element.ime == widget.projekt.ime);

                          Predmet oldProjekt = predmeti[projektIndex];
                          predmeti[projektIndex] = Predmet(
                              kont: oldProjekt.kont,
                              ID: oldProjekt.ID,
                              ime: oldProjekt.ime,
                              kolicina: (double.parse(oldProjekt.kolicina) + 1)
                                  .toString(),
                              enota: oldProjekt.enota,
                              slika: oldProjekt.slika,
                              bilanca: (double.parse(oldProjekt.bilanca) +
                                      skupnabilanca)
                                  .toString(),
                              tip: oldProjekt.tip);

                          List<String> predmetiJJson = [];
                          for (int i = 0; i < predmeti.length; i++) {
                            predmetiJJson.add(jsonEncode(predmeti[i]));
                          }

                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(ID)
                              .update({'predmeti': predmetiJJson});

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
                      const BoxConstraints.tightFor(width: 100, height: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      var db = FirebaseFirestore.instance;
                      String ID = box.get('email');
                      final docRef = db.collection("Users").doc(ID);
                      docRef.get().then((DocumentSnapshot doc) {
                        List<Projekt> accounts = [];

                        final data = doc.data() as Map<String, dynamic>;
                        List<dynamic> accountsJson = data['projekti'];
                        for (int i = 0; i < accountsJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(accountsJson[i]);
                          Projekt NewAccount = Projekt.fromJson(valueMap);
                          accounts.add(NewAccount);
                        }

                        accounts.removeWhere(
                            (element) => element.ID == widget.projekt.ID);

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
