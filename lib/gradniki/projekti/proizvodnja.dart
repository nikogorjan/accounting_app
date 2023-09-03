import 'dart:convert';

import 'package:accounting_app/gradniki/projekti/projekt_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/projekt.dart';
import 'add_projekt_button.dart';

class Proizvodnja extends StatefulWidget {
  const Proizvodnja({super.key});

  @override
  State<Proizvodnja> createState() => _ProizvodnjaState();
}

class _ProizvodnjaState extends State<Proizvodnja> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //AddProjektButton(),
        SizedBox(
          width: 33,
        ),
        StreamBuilder(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return Column(
                //shrinkWrap: true,
                //physics: ClampingScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
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

                  int stProjektov = accounts.length;
                  int stVrstic;
                  int prvaVrsticacount = 0;
                  if (stProjektov < 4) {
                    stVrstic = 1;
                    prvaVrsticacount = accounts.length;
                  } else {
                    stVrstic = 1;
                    stProjektov = stProjektov - 3;
                    int vrstice = (stProjektov / 4).ceil();
                    stVrstic += vrstice;
                  }

                  bool prvaVrstica = true;
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
                        AddProjektButton(),
                        for (int i = 0; i < accounts.length; i++)
                          ProjektCard(projekt: accounts[i])
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
      ],
    );
  }
}
