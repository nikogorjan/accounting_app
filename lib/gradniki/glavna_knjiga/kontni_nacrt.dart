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

class KontniNacrt extends StatefulWidget {
  const KontniNacrt({super.key});

  @override
  State<KontniNacrt> createState() => _KontniNacrtState();
}

class _KontniNacrtState extends State<KontniNacrt> {
  final _IDController = TextEditingController();
  final _imeController = TextEditingController();
  final _tipController = TextEditingController();
  final _komentarController = TextEditingController();
  final _bilancaController = TextEditingController();

  StreamController<List<Kont>> _streamController = StreamController();
  List<String> pointList = <String>[];
  List<dynamic> alldata = [];

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
      child: Column(children: [
        Row(
          children: [
            Spacer(),
            ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(width: 150, height: 50),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        color: Colors.white))),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: ((context) => AlertDialog(
                            title: Text('Dodaj kont'),
                            content: AccountForm(),
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
          height: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: 300,
                height: 30,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ID',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 30,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ime',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 30,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tip',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 30,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Podtip',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 30,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bilanca',
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
          height: 0,
        ),
        StreamBuilder(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  List<dynamic> accountsJson = data['konti'];
                  List<Kont> accounts = [];
                  for (int i = 0; i < accountsJson.length; i++) {
                    Map<String, dynamic> valueMap =
                        json.decode(accountsJson[i]);
                    Kont NewAccount = Kont.fromJson(valueMap);
                    accounts.add(NewAccount);
                  }
                  return Column(
                    children: [
                      for (int i = 0; i < accounts.length; i++) ...[
                        AccountRow(
                          ID: accounts[i].ID,
                          ime: accounts[i].ime,
                          tip: accounts[i].tip,
                          podtip: accounts[i].podtip,
                          bilanca: accounts[i].bilanca,
                          amortizacija: accounts[i].amortizacija,
                        ),
                        Divider(
                          height: 0,
                        )
                      ],
                    ],
                  );
                }).toList(),
              );
            }),
      ]),
    );
  }
}
