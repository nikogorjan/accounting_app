import 'dart:convert';

import 'package:accounting_app/objekti/vnos_v_dnevnik.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../api/pdf_income_statement_api.dart';
import '../../data/data.dart';
import '../../objekti/kont.dart';

class IncomeStatementForm extends StatefulWidget {
  const IncomeStatementForm({super.key});

  @override
  State<IncomeStatementForm> createState() => _IncomeStatementFormState();
}

class _IncomeStatementFormState extends State<IncomeStatementForm> {
  DateTime date1 = DateTime.now();
  DateTime date2 = DateTime.now();
  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        date1 = value!;
      });
    });
  }

  void _showDatePicker2() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        date2 = value!;
      });
    });
  }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  List<Kont> prihodkiOdhodki = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            width: 340,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(width: 200, height: 75),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xEEEEEEEE),
                ),
                onPressed: _showDatePicker,
                child: Center(
                  child: Text(
                    'Začetni datum',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: 340,
            child: Center(
              child: Text(
                "${date1.day}. ${date1.month}. ${date1.year}",
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 340,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(width: 200, height: 75),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xEEEEEEEE),
                ),
                onPressed: _showDatePicker2,
                child: Center(
                  child: Text(
                    'Končni datum',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: 340,
            child: Center(
              child: Text(
                "${date2.day}. ${date2.month}. ${date2.year}",
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 150, height: 50),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                  textStyle: MaterialStateProperty.all(const TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                      color: Colors.white))),
              onPressed: () {
                List<Kont> accounts = [];
                PdfIncomeStatement api = PdfIncomeStatement();
                var db = FirebaseFirestore.instance;
                String ID = box.get('email');
                final docRef = db.collection("Users").doc(ID);
                docRef.get().then((DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  List<dynamic> accountsJson = data['konti'];
                  List<VnosVDnevnik> vnosi = [];
                  List<dynamic> vnosiJson = data['vnosi v dnevnik'];

                  for (int i = 0; i < accountsJson.length; i++) {
                    Map<String, dynamic> valueMap =
                        json.decode(accountsJson[i]);
                    Kont NewAccount = Kont.fromJson(valueMap);
                    accounts.add(NewAccount);
                  }

                  for (int i = 0; i < vnosiJson.length; i++) {
                    Map<String, dynamic> valueMap = json.decode(vnosiJson[i]);
                    VnosVDnevnik NewAccount = VnosVDnevnik.fromJson(valueMap);
                    vnosi.add(NewAccount);
                  }

                  api.date1 = date1;
                  api.date2 = date2;
                  api.konti = accounts;
                  api.vnosiVDnevnik = vnosi;
                  api.createPdf();
                });
              },
              child: Text(
                'Generiraj',
              ),
            ),
          )
        ],
      ),
    );
  }
}
