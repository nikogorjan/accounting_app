import 'dart:convert';

import 'package:accounting_app/gradniki/projekti/plan_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/plan.dart';

class PlaniranjeStoritevMobile extends StatefulWidget {
  const PlaniranjeStoritevMobile({super.key});

  @override
  State<PlaniranjeStoritevMobile> createState() =>
      _PlaniranjeStoritevMobileState();
}

class _PlaniranjeStoritevMobileState extends State<PlaniranjeStoritevMobile> {
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

                  return Column(
                    //shrinkWrap: true,
                    //physics: ClampingScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      List<dynamic> accountsJson = data['planirane storitve'];
                      List<Plan> accounts = [];
                      for (int i = 0; i < accountsJson.length; i++) {
                        Map<String, dynamic> valueMap =
                            json.decode(accountsJson[i]);
                        Plan NewAccount = Plan.fromJson(valueMap);
                        accounts.add(NewAccount);
                      }

                      return SizedBox(
                        width: 1300,
                        //height: 900,
                        child: GridView.count(
                          shrinkWrap: true,
                          primary: false,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                          crossAxisCount: 4,
                          children: <Widget>[
                            for (int i = 0; i < accounts.length; i++)
                              PlanCard(plan: accounts[i])
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
          ],
        ));
  }
}
