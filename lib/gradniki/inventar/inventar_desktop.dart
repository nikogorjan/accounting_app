import 'dart:convert';

import 'package:accounting_app/gradniki/inventar/item_form.dart';
import 'package:accounting_app/gradniki/inventar/item_row.dart';
import 'package:accounting_app/objekti/predmet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../data/data.dart';
import '../../objekti/kont.dart';

class InventarDesktop extends StatefulWidget {
  const InventarDesktop({super.key});

  @override
  State<InventarDesktop> createState() => _InventarDesktopState();
}

class _InventarDesktopState extends State<InventarDesktop> {
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
            child: Text(
              'Inventar',
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 36),
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
                      child: Text('Predmeti',
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
          Divider(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
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
                              content: ItemForm(),
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
                  width: 375,
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ime',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 375,
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Količina',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 375,
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tip',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 375,
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
            height: 5,
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
                    List<dynamic> accountsJson = data['predmeti'];
                    List<Predmet> predmeti = [];
                    for (int i = 0; i < accountsJson.length; i++) {
                      Map<String, dynamic> valueMap =
                          json.decode(accountsJson[i]);
                      Predmet NewAccount = Predmet.fromJson(valueMap);
                      predmeti.add(NewAccount);
                    }
                    predmeti.sort(
                      (a, b) => a.ime.compareTo(b.ime),
                    );
                    return Column(
                      children: [
                        for (int i = 0; i < predmeti.length; i++) ...[
                          ItemRow(predmet: predmeti[i]),
                          Divider(
                            height: 5,
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
