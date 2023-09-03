import 'dart:convert';

import 'package:accounting_app/objekti/delavec.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import 'delavec_form.dart';
import 'delavec_row.dart';
import 'delavec_row_mobile.dart';

class ZaposleniMobile extends StatefulWidget {
  const ZaposleniMobile({super.key});

  @override
  State<ZaposleniMobile> createState() => _ZaposleniMobileState();
}

class _ZaposleniMobileState extends State<ZaposleniMobile> {
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
                      List<dynamic> accountsJson = data['zaposleni'];
                      List<Delavec> accounts = [];
                      for (int i = 0; i < accountsJson.length; i++) {
                        Map<String, dynamic> valueMap =
                            json.decode(accountsJson[i]);
                        Delavec NewAccount = Delavec.fromJson(valueMap);
                        accounts.add(NewAccount);
                      }

                      return Column(
                        children: [
                          for (int i = 0; i < accounts.length; i++) ...[
                            DelavecRowMobile(
                              delavec: accounts[i],
                            ),
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
