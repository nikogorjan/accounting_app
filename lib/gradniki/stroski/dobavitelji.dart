import 'dart:convert';

import 'package:accounting_app/gradniki/stroski/dobavitelj_row.dart';
import 'package:accounting_app/gradniki/stroski/dobavitelji_form.dart';
import 'package:accounting_app/objekti/dobavitelj.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';

class Dobavitelji extends StatefulWidget {
  const Dobavitelji({super.key});

  @override
  State<Dobavitelji> createState() => _DobaviteljiState();
}

class _DobaviteljiState extends State<Dobavitelji> {
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
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              //Spacer(),
              ConstrainedBox(
                constraints:
                    const BoxConstraints.tightFor(width: 150, height: 50),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0)),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                          color: Colors.white))),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              title: Text(''),
                              content: DobaviteljForm(),
                            )));
                  },
                  child: Text(
                    'Dodaj',
                  ),
                ),
              )
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
                      'Naziv',
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
                      'Telefonska številka',
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
                      'E-naslov',
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
                      'Lokacija',
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
                      'Bilanca',
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
                    List<dynamic> accountsJson = data['dobavitelji'];
                    List<Dobavitelj> accounts = [];
                    for (int i = 0; i < accountsJson.length; i++) {
                      Map<String, dynamic> valueMap =
                          json.decode(accountsJson[i]);
                      Dobavitelj NewAccount = Dobavitelj.fromJson(valueMap);
                      accounts.add(NewAccount);
                    }

                    return Column(
                      children: [
                        for (int i = 0; i < accounts.length; i++) ...[
                          DobaviteljRow(dobavitelj: accounts[i]),
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
