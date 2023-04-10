import 'dart:convert';

import 'package:accounting_app/gradniki/stroski/racun_row_mobile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/racun_strosek.dart';

class StroskiRacuniMobile extends StatefulWidget {
  const StroskiRacuniMobile({super.key});

  @override
  State<StroskiRacuniMobile> createState() => _StroskiRacuniMobileState();
}

class _StroskiRacuniMobileState extends State<StroskiRacuniMobile> {
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
                    List<dynamic> accountsJson = data['stroski'];
                    List<RacunStrosek> accounts = [];
                    for (int i = 0; i < accountsJson.length; i++) {
                      Map<String, dynamic> valueMap =
                          json.decode(accountsJson[i]);
                      RacunStrosek NewAccount = RacunStrosek.fromJson(valueMap);
                      accounts.add(NewAccount);
                    }

                    accounts.sort(
                      (a, b) => a.datum.compareTo(b.datum),
                    );
                    accounts = accounts.reversed.toList();

                    return Column(
                      children: [
                        for (int i = 0; i < accounts.length; i++) ...[
                          RacunRowMobile(rc: accounts[i]),
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
