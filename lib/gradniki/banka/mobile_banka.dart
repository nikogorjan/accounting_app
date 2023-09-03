import 'dart:convert';

import 'package:accounting_app/gradniki/banka/transakcije_row_mobile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/banka.dart';
import '../../objekti/transakcija.dart';
import 'add_bank_button.dart';
import 'add_bank_form.dart';
import 'bank_card.dart';
import 'mobile_add_bank_form.dart';

class BankaMobile extends StatefulWidget {
  const BankaMobile({super.key});

  @override
  State<BankaMobile> createState() => _BankaMobileState();
}

class _BankaMobileState extends State<BankaMobile> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height - 80,
            child: ListView(
              children: [
                Text(
                  'Banka',
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      height: 50,
                      child: TextButton(
                          onPressed: () {},
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Računi',
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 18,
                                    color: Colors.black)),
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Divider(
                    height: 20,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      //AddBankButton(),
                      SizedBox(
                        width: 20,
                      ),
                      StreamBuilder(
                          stream: _usersStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading");
                            }

                            return Column(
                              //shrinkWrap: true,
                              //physics: ClampingScrollPhysics(),
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                List<dynamic> accountsJson = data['banka'];
                                List<Banka> accounts = [];
                                for (int i = 0; i < accountsJson.length; i++) {
                                  Map<String, dynamic> valueMap =
                                      json.decode(accountsJson[i]);
                                  Banka NewAccount = Banka.fromJson(valueMap);
                                  accounts.add(NewAccount);
                                }

                                return Row(
                                  children: [
                                    for (int i = 0;
                                        i < accounts.length;
                                        i++) ...[
                                      BankCard(card: accounts[i]),
                                      SizedBox(
                                        width: 20,
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
                SizedBox(
                  height: 10,
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
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          List<dynamic> accountsJson = data['banka'];
                          List<Banka> accounts = [];
                          for (int i = 0; i < accountsJson.length; i++) {
                            Map<String, dynamic> valueMap =
                                json.decode(accountsJson[i]);
                            Banka NewAccount = Banka.fromJson(valueMap);
                            accounts.add(NewAccount);
                          }

                          if (global.card == '') {
                            global.card = accounts[0].ID;
                          }

                          int index = accounts.indexWhere(
                              (element) => element.ID == global.card);
                          List<dynamic> transakcije =
                              accounts[index].transakcije;
                          List<Transakcija> transactions = [];
                          for (int j = 0; j < transakcije.length; j++) {
                            Map<String, dynamic> valueMap =
                                json.decode(transakcije[j]);
                            Transakcija NewAccount =
                                Transakcija.fromJson(valueMap);
                            transactions.add(NewAccount);
                          }

                          transactions.sort(
                            (a, b) => a.datum.compareTo(b.datum),
                          );
                          transactions = transactions.reversed.toList();

                          return Column(
                            children: [
                              for (int i = 0; i < transactions.length; i++) ...[
                                TransakcijeRowMobile(
                                    transakcija: transactions[i]),
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
            )),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(content: AddBankFormMobile());
                  });
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
