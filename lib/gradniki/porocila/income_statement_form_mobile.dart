import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:convert';

import 'package:accounting_app/objekti/vnos_v_dnevnik.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../api/pdf_income_statement_api.dart';
import '../../data/data.dart';
import '../../objekti/kont.dart';
import '../../services/storage_service.dart';

class IncomeStatementFormMobile extends StatefulWidget {
  const IncomeStatementFormMobile({super.key});

  @override
  State<IncomeStatementFormMobile> createState() =>
      _IncomeStatementFormMobileState();
}

class _IncomeStatementFormMobileState extends State<IncomeStatementFormMobile> {
  String dropdownValue = '';
  bool changed = false;
  String kontKapital = '';

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
      width: 300,
      height: 500,
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            width: 260,
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
            width: 260,
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
            width: 260,
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
            width: 260,
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
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 30,
                  width: 260,
                  child: Text('KONT DAVKOV'),
                ),
              )),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 260,
                  child: SizedBox(
                      width: 260,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _usersStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading");
                          }

                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;

                              List<dynamic> accountsJson = data['konti'];
                              List<Kont> accounts = [];
                              List<String> accountNames = [];
                              for (int i = 0; i < accountsJson.length; i++) {
                                Map<String, dynamic> valueMap =
                                    json.decode(accountsJson[i]);
                                Kont NewAccount = Kont.fromJson(valueMap);
                                accounts.add(NewAccount);
                              }

                              for (int j = 0; j < accounts.length; j++) {
                                String str = accounts[j].ime;
                                accountNames.add(str);
                              }
                              dropdownValue = accountNames.first;
                              if (changed == false) {
                                kontKapital = dropdownValue;
                              }
                              //debetItem = dropdownValue;

                              return Container(
                                width: 260,
                                height: 70,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),

                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.blueAccent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.grey), //<-- SEE HERE
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  value: dropdownValue,
                                  elevation: 16,
                                  style:
                                      const TextStyle(fontFamily: 'OpenSans'),
                                  items: accountNames
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                    kontKapital = dropdownValue;
                                    changed = true;
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        },
                      )),
                )
              ],
            ),
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
                docRef.get().then((DocumentSnapshot doc) async {
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

                  api.davki = kontKapital;
                  api.date1 = date1;
                  api.date2 = date2;
                  api.konti = accounts;
                  api.vnosiVDnevnik = vnosi;
                  api.createPdf();

                  path = await box.get('data');
                  Storage storage = Storage();
                  final url = await storage.UploadFileMobilePdf(
                      path, 'name', box.get('email'));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PdfViewerPage(url: url),
                    ),
                  );
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

String path = '';

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfPdfViewer.network(
      path,
    ));
  }
}

void _openNewScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NewScreen(),
    ),
  );
}

class PdfViewerPage extends StatelessWidget {
  final String url;

  const PdfViewerPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: SfPdfViewer.network(
        url,
        canShowScrollHead: false,
      ),
    );
  }
}
