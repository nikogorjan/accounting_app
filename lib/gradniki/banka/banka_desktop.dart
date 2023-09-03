import 'dart:convert';

import 'package:accounting_app/gradniki/banka/add_bank_button.dart';
import 'package:accounting_app/gradniki/banka/bank_card.dart';
import 'package:accounting_app/gradniki/banka/transakcije_row.dart';
import 'package:accounting_app/objekti/banka.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../data/data.dart';
import '../../objekti/transakcija.dart';

class BankaDesktop extends StatefulWidget {
  const BankaDesktop({super.key});

  @override
  State<BankaDesktop> createState() => _BankaDesktopState();
}

class _BankaDesktopState extends State<BankaDesktop> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                'Banka',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 36),
              ),
            ),
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
                              fontSize: 24,
                              color: Colors.black)),
                    )),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
            child: Divider(
              height: 20,
            ),
          ),
          Row(
            children: [
              AddBankButton(),
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
                            for (int i = 0; i < accounts.length; i++) ...[
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
          SizedBox(
            height: 40,
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
                      'Datum',
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
                      'Prejemnik/Plačnik',
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
                      'Kont',
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
                      'Prejeto',
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
                      'Plačilo',
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

                    int index = accounts
                        .indexWhere((element) => element.ID == global.card);
                    List<dynamic> transakcije = accounts[index].transakcije;
                    List<Transakcija> transactions = [];
                    for (int j = 0; j < transakcije.length; j++) {
                      Map<String, dynamic> valueMap =
                          json.decode(transakcije[j]);
                      Transakcija NewAccount = Transakcija.fromJson(valueMap);
                      transactions.add(NewAccount);
                    }

                    transactions.sort(
                      (a, b) => a.datum.compareTo(b.datum),
                    );
                    transactions = transactions.reversed.toList();

                    return Column(
                      children: [
                        for (int i = 0; i < transactions.length; i++) ...[
                          Transakcije(transakcija: transactions[i]),
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
