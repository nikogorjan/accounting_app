import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/vnos_v_dnevnik.dart';
import 'journal_entry_row.dart';
import 'journal_entry_row_mobile.dart';

class DnevnikMobile extends StatefulWidget {
  const DnevnikMobile({super.key});

  @override
  State<DnevnikMobile> createState() => _DnevnikMobileState();
}

class _DnevnikMobileState extends State<DnevnikMobile> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 203,
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                      child: Text(
                'DATUM',
                style: TextStyle(fontFamily: 'OpenSans'),
              ))),
              Expanded(
                  child: Container(
                      child: Text('KONT',
                          style: TextStyle(fontFamily: 'OpenSans')))),
              Expanded(
                  child: Container(
                      child: Text('DEBET',
                          style: TextStyle(fontFamily: 'OpenSans')))),
              Expanded(
                  child: Container(
                      child: Text('KREDIT',
                          style: TextStyle(fontFamily: 'OpenSans')))),
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
                    List<dynamic> accountsJson = data['vnosi v dnevnik'];
                    List<VnosVDnevnik> accounts = [];
                    for (int i = 0; i < accountsJson.length; i++) {
                      Map<String, dynamic> valueMap =
                          json.decode(accountsJson[i]);
                      VnosVDnevnik NewAccount = VnosVDnevnik.fromJson(valueMap);
                      accounts.add(NewAccount);
                    }
                    accounts.sort(
                      (a, b) => a.datum.compareTo(b.datum),
                    );
                    accounts = accounts.reversed.toList();
                    return Column(
                      children: [
                        for (int i = 0; i < accounts.length; i++) ...[
                          JournalEntryRowMobile(vnos: accounts[i]),
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
