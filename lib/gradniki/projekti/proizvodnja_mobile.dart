import 'dart:convert';

import 'package:accounting_app/gradniki/projekti/plan_card.dart';
import 'package:accounting_app/gradniki/projekti/projekt_card.dart';
import 'package:accounting_app/gradniki/projekti/projekt_card_mobile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/plan.dart';
import '../../objekti/projekt.dart';

class ProizvodnjaMobile extends StatefulWidget {
  const ProizvodnjaMobile({super.key});

  @override
  State<ProizvodnjaMobile> createState() => _ProizvodnjaMobileState();
}

class _ProizvodnjaMobileState extends State<ProizvodnjaMobile> {
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
            SizedBox(
              height: 20,
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
                    //physics: ClampingScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      List<dynamic> accountsJson = data['projekti'];
                      List<Projekt> accounts = [];
                      for (int i = 0; i < accountsJson.length; i++) {
                        Map<String, dynamic> valueMap =
                            json.decode(accountsJson[i]);
                        Projekt NewAccount = Projekt.fromJson(valueMap);
                        accounts.add(NewAccount);
                      }

                      return Column(
                        children: <Widget>[
                          for (int i = 0; i < accounts.length; i++) ...[
                            SizedBox(
                                height: 400,
                                child: ProjektCardMobile(projekt: accounts[i])),
                            SizedBox(
                              height: 20,
                            ),
                          ]
                        ],
                      );
                    }).toList(),
                  );
                }),
          ],
        ));
  }
}
