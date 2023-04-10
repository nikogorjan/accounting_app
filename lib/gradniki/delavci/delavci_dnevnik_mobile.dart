import 'package:accounting_app/gradniki/delavci/dodaj_ure_form.dart';
import 'package:accounting_app/gradniki/delavci/ure_row.dart';
import 'package:accounting_app/gradniki/delavci/ure_row_mobile.dart';
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

class DelavciDnevnikMobile extends StatefulWidget {
  const DelavciDnevnikMobile({super.key});

  @override
  State<DelavciDnevnikMobile> createState() => _DelavciDnevnikMobileState();
}

class _DelavciDnevnikMobileState extends State<DelavciDnevnikMobile> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height - 203,
        child: Column(
          children: [
            Divider(
              height: 1,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                        child: Text(
                  'Datum',
                  style: TextStyle(fontFamily: 'OpenSans'),
                ))),
                Expanded(
                    child: Container(
                        child: Text(
                  'Delavec',
                  style: TextStyle(fontFamily: 'OpenSans'),
                ))),
                Expanded(
                    child: Container(
                        child: Text(
                  'Število ur',
                  style: TextStyle(fontFamily: 'OpenSans'),
                ))),
              ],
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
                      List<dynamic> accountsJson = data['ure dela'];
                      List<Delo> accounts = [];
                      for (int i = 0; i < accountsJson.length; i++) {
                        Map<String, dynamic> valueMap =
                            json.decode(accountsJson[i]);
                        Delo NewAccount = Delo.fromJson(valueMap);
                        accounts.add(NewAccount);
                      }
                      accounts.sort(
                        (a, b) => a.datum.compareTo(b.datum),
                      );
                      return Column(
                        children: [
                          for (int i = 0; i < accounts.length; i++) ...[
                            UreRowMobile(delo: accounts[i]),
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
        ));
  }
}
