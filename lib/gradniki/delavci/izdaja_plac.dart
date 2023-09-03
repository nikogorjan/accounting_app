import 'package:accounting_app/gradniki/delavci/dodaj_ure_form.dart';
import 'package:accounting_app/gradniki/delavci/ure_row.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:async';
import 'dart:convert';

import 'package:accounting_app/data/data.dart';
import 'package:accounting_app/gradniki/glavna_knjiga/account_form.dart';
import 'package:accounting_app/gradniki/glavna_knjiga/account_row.dart';
import 'package:accounting_app/objekti/kont.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:accounting_app/data/konti.dart';

import '../../objekti/delo.dart';
import '../../objekti/placa.dart';
import 'dodaj_placo_form.dart';
import 'izdaja_plac_row.dart';

class IzdajaPlac extends StatefulWidget {
  const IzdajaPlac({super.key});

  @override
  State<IzdajaPlac> createState() => _IzdajaPlacState();
}

class _IzdajaPlacState extends State<IzdajaPlac> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              //Spacer(),
              ConstrainedBox(
                constraints:
                    const BoxConstraints.tightFor(width: 150, height: 50),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0)),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                          color: Colors.white))),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              //title: Text('Dodaj kont'),
                              content: DodajPlacoForm(),
                            )));
                  },
                  child: Text(
                    'Dodaj',
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: 500,
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Datum',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 500,
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Delavec',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 500,
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Vsota plače',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 1,
          ),
          StreamBuilder(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    List<dynamic> accountsJson = data['place'];
                    List<Placa> accounts = [];
                    for (int i = 0; i < accountsJson.length; i++) {
                      Map<String, dynamic> valueMap =
                          json.decode(accountsJson[i]);
                      Placa NewAccount = Placa.fromJson(valueMap);
                      accounts.add(NewAccount);
                    }
                    accounts.sort(
                      (a, b) => a.datum.compareTo(b.datum),
                    );
                    return Column(
                      children: [
                        for (int i = 0; i < accounts.length; i++) ...[
                          IzdajaPlacRow(placa: accounts[i]),
                          Divider(
                            height: 1,
                          )
                        ],
                      ],
                    );
                  }).toList(),
                );
              }),
        ],
      ),
    );
  }
}
