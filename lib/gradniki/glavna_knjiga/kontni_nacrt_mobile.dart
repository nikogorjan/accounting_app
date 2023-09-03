import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/banka.dart';
import '../../objekti/kont.dart';
import '../../objekti/transakcija.dart';
import '../banka/bank_card.dart';
import '../banka/mobile_add_bank_form.dart';
import '../banka/transakcije_row_mobile.dart';
import 'account_form.dart';
import 'account_row_mobile.dart';

class KontniNacrtMobile extends StatefulWidget {
  const KontniNacrtMobile({super.key});

  @override
  State<KontniNacrtMobile> createState() => _KontniNacrtMobileState();
}

class _KontniNacrtMobileState extends State<KontniNacrtMobile> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                        List<dynamic> accountsJson = data['konti'];
                        List<Kont> accounts = [];
                        for (int i = 0; i < accountsJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(accountsJson[i]);
                          Kont NewAccount = Kont.fromJson(valueMap);
                          accounts.add(NewAccount);
                        }
                        accounts.sort(
                          (a, b) => a.ID.compareTo(b.ID),
                        );
                        return Column(
                          children: [
                            for (int i = 0; i < accounts.length; i++) ...[
                              AccountRowMobile(
                                ID: accounts[i].ID,
                                ime: accounts[i].ime,
                                tip: accounts[i].tip,
                                podtip: accounts[i].podtip,
                                bilanca: accounts[i].bilanca,
                                amortizacija: accounts[i].amortizacija,
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
          ),
        ),
      ],
    );
  }
}
