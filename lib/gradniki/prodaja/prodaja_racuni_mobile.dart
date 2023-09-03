import 'dart:convert';

import 'package:accounting_app/gradniki/prodaja/prodaja_dodaj_racun.dart';
import 'package:accounting_app/gradniki/prodaja/prodaja_racun_row.dart';
import 'package:accounting_app/gradniki/prodaja/prodaja_racun_row_mobile.dart';
import 'package:accounting_app/objekti/racun_prodaja.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../stroski/dodaj_racun.dart';

class ProdajaRacuniMobile extends StatefulWidget {
  const ProdajaRacuniMobile({super.key});

  @override
  State<ProdajaRacuniMobile> createState() => _ProdajaRacuniMobileState();
}

class _ProdajaRacuniMobileState extends State<ProdajaRacuniMobile> {
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
                    List<dynamic> accountsJson = data['prodaja'];
                    List<RacunProdaja> accounts = [];
                    for (int i = 0; i < accountsJson.length; i++) {
                      Map<String, dynamic> valueMap =
                          json.decode(accountsJson[i]);
                      RacunProdaja NewAccount = RacunProdaja.fromJson(valueMap);
                      accounts.add(NewAccount);
                    }

                    accounts.sort(
                      (a, b) => a.datum.compareTo(b.datum),
                    );
                    accounts = accounts.reversed.toList();

                    return Column(
                      children: [
                        for (int i = 0; i < accounts.length; i++) ...[
                          ProdajaRacunRowMobile(rp: accounts[i]),
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
