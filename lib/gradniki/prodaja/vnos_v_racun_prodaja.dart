import 'dart:convert';

import 'package:accounting_app/objekti/produkt_storitev.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/kont.dart';

class VnosVRacunProdaja extends StatefulWidget {
  const VnosVRacunProdaja(
      {super.key, required this.index, required this.onFormSubmitted});
  final int index;
  final Function(int, String, String, String, String, String, String, String)
      onFormSubmitted;

  @override
  State<VnosVRacunProdaja> createState() => _VnosVRacunProdajaState();
}

class _VnosVRacunProdajaState extends State<VnosVRacunProdaja> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  final _testController = TextEditingController();
  final _test2Controller = TextEditingController();
  var _test3Controller = TextEditingController();
  String dropdownValue = '';
  String controller3 = '0';

  void _submitForm() {
    try {
      widget.onFormSubmitted(
          widget.index,
          value2,
          value3,
          tip,
          _testController.text.trim(),
          _test2Controller.text.trim(),
          controller3,
          _test3Controller.text.trim());
    } catch (e) {
      print('Error submitting form: $e');
      // handle the error here (e.g. display an error message to the user, reset the form, etc.)
    }
  }

  late String dropdownValue2;
  late String dropdownValue3;

  String value2 = '';
  String value3 = '';
  bool val2changed = false;
  bool val3changed = false;

  void _onTextFieldChanged(String value) {
    setState(() {
      //2-cena 3-ddv
      double cenaZDdv = double.parse(_test2Controller.text.trim()) *
              (double.parse(_test3Controller.text.trim()) / 100) +
          double.parse(_test2Controller.text.trim());
      controller3 = (double.parse(_testController.text.trim()) * cenaZDdv)
          .toStringAsFixed(2);
    });
    _submitForm();
  }

  String tip = '';

  @override
  void initState() {
    _testController.text = '0';
    _test2Controller.text = '0';
    _test3Controller.text = '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 283,
            height: 50,
            child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    List<dynamic> predmetiJson = data['produkti in storitve'];
                    List<ProduktStoritev> predmeti = [];
                    List<String> predmetiNames = [];

                    for (int i = 0; i < predmetiJson.length; i++) {
                      Map<String, dynamic> valueMap =
                          json.decode(predmetiJson[i]);
                      ProduktStoritev NewAccount =
                          ProduktStoritev.fromJson(valueMap);
                      predmeti.add(NewAccount);
                    }

                    for (int j = 0; j < predmeti.length; j++) {
                      String str = predmeti[j].naziv;
                      predmetiNames.add(str);
                    }
                    dropdownValue2 = predmetiNames.first;

                    if (val2changed == false) {
                      value2 = dropdownValue2;
                      int ii = predmeti
                          .indexWhere((element) => element.naziv == value2);
                      tip = predmeti[ii].PS;
                    }

                    //debetItem = dropdownValue;

                    return Container(
                      width: 283,
                      height: 50,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),

                            //<-- SEE HERE
                            borderSide:
                                BorderSide(width: 1, color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        value: dropdownValue2,
                        elevation: 16,
                        style: const TextStyle(fontFamily: 'OpenSans'),
                        items: predmetiNames
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontFamily: 'OpenSans', color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue2 = value!;
                          });
                          value2 = dropdownValue2;
                          val2changed = true;
                          int ii = predmeti
                              .indexWhere((element) => element.naziv == value2);
                          tip = predmeti[ii].PS;
                          _submitForm();
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            )),
        SizedBox(
            width: 283,
            height: 50,
            child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    List<dynamic> predmetiJson = data['konti'];
                    List<Kont> predmeti = [];
                    List<String> predmetiNames = [];

                    for (int i = 0; i < predmetiJson.length; i++) {
                      Map<String, dynamic> valueMap =
                          json.decode(predmetiJson[i]);
                      Kont NewAccount = Kont.fromJson(valueMap);
                      predmeti.add(NewAccount);
                    }

                    for (int j = 0; j < predmeti.length; j++) {
                      String str = predmeti[j].ime;
                      predmetiNames.add(str);
                    }
                    dropdownValue3 = predmetiNames.first;

                    if (val3changed == false) {
                      value3 = dropdownValue3;
                    }

                    //debetItem = dropdownValue;

                    return Container(
                      width: 283,
                      height: 50,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),

                            //<-- SEE HERE
                            borderSide:
                                BorderSide(width: 1, color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        value: dropdownValue3,
                        elevation: 16,
                        style: const TextStyle(fontFamily: 'OpenSans'),
                        items: predmetiNames
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontFamily: 'OpenSans', color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue3 = value!;
                          });
                          value3 = dropdownValue3;
                          val3changed = true;
                          _submitForm();
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            )),
        Container(
          height: 50,
          width: 283,
          child: TextField(
              controller: _testController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),

                    //<-- SEE HERE
                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(0),
                  ),
                  hintText: '',
                  hintStyle:
                      TextStyle(fontFamily: 'OpenSans', color: Colors.black)),
              onChanged: _onTextFieldChanged /*widget.onTextChanged*/),
        ),
        Container(
          height: 50,
          width: 283,
          child: TextField(
              controller: _test2Controller,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),

                    //<-- SEE HERE
                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(0),
                  ),
                  hintText: '',
                  hintStyle:
                      TextStyle(fontFamily: 'OpenSans', color: Colors.black)),
              onChanged: _onTextFieldChanged /*widget.onTextChanged*/),
        ),
        Container(
          height: 50,
          width: 283,
          child: TextField(
              controller: _test3Controller,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),

                    //<-- SEE HERE
                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(0),
                  ),
                  hintText: '',
                  hintStyle:
                      TextStyle(fontFamily: 'OpenSans', color: Colors.black)),
              onChanged: _onTextFieldChanged /*widget.onTextChanged*/),
        ),
        Container(
          height: 50,
          width: 283,
          padding: EdgeInsets.all(10),
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(controller3,
                style: TextStyle(fontFamily: 'OpenSans', color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
