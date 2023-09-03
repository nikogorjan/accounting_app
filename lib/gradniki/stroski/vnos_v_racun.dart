import 'dart:convert';

import 'package:accounting_app/objekti/predmet.dart';
import 'package:accounting_app/objekti/storitev.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/kont.dart';

class VnosVRacun extends StatefulWidget {
  const VnosVRacun(
      {super.key,
      required this.onTextChanged,
      required this.onDropdownChanged,
      required this.onDropdownChanged2,
      required this.onDropdownChanged3,
      required this.onTextChanged2,
      required this.index,
      required this.onFormSubmitted});
  final ValueChanged<String> onTextChanged;
  final ValueChanged<String> onTextChanged2;

  final ValueChanged<String?> onDropdownChanged;
  final ValueChanged<String?> onDropdownChanged2;
  final ValueChanged<String?> onDropdownChanged3;
  final int index;
  final Function(int, String, String, String, String, String) onFormSubmitted;

  @override
  State<VnosVRacun> createState() => _VnosVRacunState();
}

class _VnosVRacunState extends State<VnosVRacun> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  List<String> tip = <String>[
    'Inventar',
    'Storitev',
  ];
  String dropdownValue = 'Inventar';
  late String dropdownValue2;
  String dropdownValue3 = '';

  final ValueNotifier<String> dropdownValue2notifier =
      ValueNotifier<String>('predmeti');
  String changedVal = 'Inventar';
  final _testController = TextEditingController();
  final _test2Controller = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      widget.onDropdownChanged(dropdownValue);
    });
    super.initState();
  }

  String returnSubtypeString(String tip) {
    String ret = '';
    if (tip == 'Inventar') {
      ret = 'predmeti';
    } else {
      ret = 'storitve';
    }
    return ret;
  }

  String value2 = '';
  String value3 = '';

  void _submitForm() {
    try {
      widget.onFormSubmitted(widget.index, changedVal, value2, value3,
          _testController.text.trim(), _test2Controller.text.trim());
    } catch (e) {
      print('Error submitting form: $e');
      // handle the error here (e.g. display an error message to the user, reset the form, etc.)
    }
  }

  void _onTextFieldChanged2(String value) {
    setState(() {
      //_test2Controller.text = value;
    });
    _submitForm();
  }

  void _onTextFieldChanged(String value) {
    setState(() {
      //_testController.text = value;
    });
    _submitForm();
  }

  bool val2changed = false;
  bool val3changed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 340,
          height: 50,
          child: DropdownButtonFormField<String>(
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
            ),
            value: dropdownValue,
            elevation: 16,
            style: const TextStyle(fontFamily: 'OpenSans'),
            items: tip.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontFamily: 'OpenSans', color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
                dropdownValue2notifier.value =
                    returnSubtypeString(dropdownValue);

                //widget.onDropdownChanged(value);
              });
              changedVal = dropdownValue;
              _submitForm();
              //dropdownValue2notifier.value = returnSubtypeString(dropdownValue);
            },
          ),
        ),
        SizedBox(
            width: 340,
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

                    List<dynamic> predmetiJson = data['predmeti'];
                    List<dynamic> storitveJson = data['storitve'];
                    List<Predmet> predmeti = [];
                    List<Storitev> storitve = [];
                    List<String> predmetiNames = [];
                    List<String> storitveNames = [];

                    if (dropdownValue2notifier.value == 'predmeti') {
                      for (int i = 0; i < predmetiJson.length; i++) {
                        Map<String, dynamic> valueMap =
                            json.decode(predmetiJson[i]);
                        Predmet NewAccount = Predmet.fromJson(valueMap);
                        predmeti.add(NewAccount);
                      }

                      for (int j = 0; j < predmeti.length; j++) {
                        String str = predmeti[j].ime;
                        predmetiNames.add(str);
                      }
                      dropdownValue2 = predmetiNames.first;
                      widget.onDropdownChanged2(predmetiNames.first);

                      if (val2changed == false) {
                        value2 = dropdownValue2;
                      }
                    } else {
                      for (int i = 0; i < storitveJson.length; i++) {
                        Map<String, dynamic> valueMap =
                            json.decode(storitveJson[i]);
                        Storitev NewAccount = Storitev.fromJson(valueMap);
                        storitve.add(NewAccount);
                      }

                      for (int j = 0; j < storitve.length; j++) {
                        String str = storitve[j].ime;
                        predmetiNames.add(str);
                      }
                      dropdownValue2 = predmetiNames.first;
                      widget.onDropdownChanged2(predmetiNames.first);

                      if (val2changed == false) {
                        value2 = dropdownValue2;
                      }
                      int i = 0;
                      //_submitForm();
                    }

                    //debetItem = dropdownValue;

                    return Container(
                      width: 340,
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
                            widget.onDropdownChanged2(value);
                          });
                          value2 = dropdownValue2;
                          val2changed = true;
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
          width: 340,
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
        SizedBox(
            width: 340,
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
                    dropdownValue3 = accountNames.first;
                    widget.onDropdownChanged3(accountNames.first);

                    if (val3changed == false) {
                      value3 = dropdownValue3;
                    }

                    //debetItem = dropdownValue;

                    return Container(
                      width: 340,
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
                        items: accountNames
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
                            widget.onDropdownChanged3(value);
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
          width: 340,
          child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              onChanged: _onTextFieldChanged2),
        ),
      ],
    );
  }
}
