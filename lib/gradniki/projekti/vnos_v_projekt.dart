import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../data/data.dart';
import '../../objekti/predmet.dart';

class VnosVProjekt extends StatefulWidget {
  const VnosVProjekt(
      {super.key, required this.index, required this.onFormSubmitted});
  final int index;
  final Function(int, String, String) onFormSubmitted;

  @override
  State<VnosVProjekt> createState() => _VnosVProjektState();
}

class _VnosVProjektState extends State<VnosVProjekt> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  String dropdownValue = '';
  final _kolicinaController = TextEditingController();

  void _submitForm() {
    try {
      widget.onFormSubmitted(
          widget.index, value1, _kolicinaController.text.trim());
    } catch (e) {
      print('Error submitting form: $e');
      // handle the error here (e.g. display an error message to the user, reset the form, etc.)
    }
  }

  void _onTextFieldChanged(String value) {
    _submitForm();
  }

  bool valChanged = false;
  String value1 = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
                    List<Predmet> predmeti = [];
                    List<String> predmetiNames = [];

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
                    dropdownValue = predmetiNames.first;

                    if (valChanged == false) {
                      value1 = dropdownValue;
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
                        value: dropdownValue,
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
                            dropdownValue = value!;
                          });
                          value1 = dropdownValue;
                          valChanged = true;

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
            controller: _kolicinaController,
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
            onChanged: _onTextFieldChanged,
          ),
        ),
      ],
    );
  }
}
