import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/predmet.dart';
import 'item_row_mobile.dart';

class InventarMobile extends StatefulWidget {
  const InventarMobile({super.key});

  @override
  State<InventarMobile> createState() => _InventarMobileState();
}

class _InventarMobileState extends State<InventarMobile> {
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
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Inventar',
                    style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),
                  ),
                ],
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
                                  fontSize: 18,
                                  color: Colors.black)),
                        )),
                  ),
                ],
              ),
              Divider(
                height: 1,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        'Ime',
                        style: TextStyle(fontFamily: 'OpenSans'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Količina',
                        style: TextStyle(fontFamily: 'OpenSans'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Tip',
                        style: TextStyle(fontFamily: 'OpenSans'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Bilanca',
                        style: TextStyle(fontFamily: 'OpenSans'),
                      ),
                    ),
                  ),
                ],
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
                        List<Predmet> accounts = [];
                        for (int i = 0; i < accountsJson.length; i++) {
                          Map<String, dynamic> valueMap =
                              json.decode(accountsJson[i]);
                          Predmet NewAccount = Predmet.fromJson(valueMap);
                          accounts.add(NewAccount);
                        }
                        accounts.sort(
                          (a, b) => a.ime.compareTo(b.ime),
                        );
                        return Column(
                          children: [
                            for (int i = 0; i < accounts.length; i++) ...[
                              ItemRowMobile(predmet: accounts[i]),
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
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
