import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:accounting_app/objekti/predmet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
//import 'dart:html' as html;
import "package:universal_html/html.dart" as html;
import '../../data/data.dart';
import '../../objekti/kont.dart';
import '../../services/storage_service.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({super.key});

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  Uint8List webImage = Uint8List(8);
  File? _pickedImage;
  String imagePath = '';
  String imageName = '';
  bool picked = false;
  final _imeController = TextEditingController();
  final _kolicinaController = TextEditingController();
  final _bilancaController = TextEditingController();
  final Storage storage = Storage();
  List<String> merskeEnote = [
    '/',
    'kg',
    'g',
    'l',
    'ml',
    'm',
    'mm',
  ];
  String dropdownValue = '/';
  String dropdownValue3 = '/';
  String izbraniKont = '';
  bool changedKont = false;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  List<String> tip = [
    'Blago',
    'Material',
    'Polproizvod',
    'Končni izdelek',
  ];
  String dropdownValue2 = 'Material';

  Color color = Colors.white;
  int _enterCounter = 0;
  int _exitCounter = 0;
  double x = 0.0;
  double y = 0.0;

  void _incrementEnter(PointerEvent details) {
    setState(() {
      _enterCounter++;
    });
  }

  void _incrementExit(PointerEvent details) {
    setState(() {
      color = Colors.white;
      _exitCounter++;
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      color = Color.fromRGBO(217, 234, 250, 0.2);
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var f = await image.readAsBytes();
      setState(() {
        webImage = f;
        imagePath = image.path;
        picked = true;
        String ID = box.get('email');
        //storage.uploadFile(imagePath, 'test', ID);
      });
      /*String ID = box.get('email');
        storage.uploadFile(imagePath, 'test', ID);*/
    } else {
      print('No image selected.');
    }
  }

  Future<void> _pickImage2() async {
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );

    if (results == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file selected.'),
        ),
      );
      return null;
    }

    imagePath = results.files.single.path!;
    imageName = results.files.single.name;

    webImage = results.files.first.bytes!;
    picked = true;
  }

  String urldata = '';
  late final file;
  late final reader;

  void uploadImage() {
    String ID = box.get('email');
    var uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      file = uploadInput.files!.first;
      reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoad.listen((event) {
        print('done');
        urldata = reader.result as String;
      });
      //storage.uploadFile(file, _imeController.text.trim(), ID);
      picked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 700,
      width: 500,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30,
                    width: 460,
                    child: Text('IME'),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 460,
                  child: TextField(
                    controller: _imeController,
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
                        hintText: '',
                        hintStyle: TextStyle(
                            fontFamily: 'OpenSans', color: Colors.black)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30,
                    width: 460,
                    child: Text('KONT'),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 460,
                  child: SizedBox(
                      width: 310,
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
                              dropdownValue3 = accountNames.first;
                              if (changedKont == false) {
                                izbraniKont = dropdownValue3;
                              }
                              //debetItem = dropdownValue;

                              return Container(
                                width: 310,
                                height: 50,
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
                                  value: dropdownValue3,
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
                                      dropdownValue3 = value!;
                                    });
                                    izbraniKont = dropdownValue3;
                                    changedKont = true;
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: 220,
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 30,
                      width: 460,
                      child: Text('ZAČETNA KOLIČINA'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 220,
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 30,
                      width: 460,
                      child: Text('MERSKA ENOTA'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: 220,
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 50,
                      //width: 460,
                      child: TextField(
                        controller: _kolicinaController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),

                              //<-- SEE HERE
                              borderSide: BorderSide(
                                  width: 1, color: Colors.blueAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.grey), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(0),
                            ),
                            hintText: '',
                            hintStyle: TextStyle(
                                fontFamily: 'OpenSans', color: Colors.black)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 220,
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 50,
                      //width: 460,
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
                        items: merskeEnote
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
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: 220,
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 30,
                      width: 460,
                      child: Text('BILANCA'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 220,
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 30,
                      width: 460,
                      child: Text('TIP'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: 220,
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 50,
                      //width: 460,
                      child: TextField(
                        controller: _bilancaController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),

                              //<-- SEE HERE
                              borderSide: BorderSide(
                                  width: 1, color: Colors.blueAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.grey), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(0),
                            ),
                            hintText: '',
                            hintStyle: TextStyle(
                                fontFamily: 'OpenSans', color: Colors.black)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 220,
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 50,
                      //width: 460,
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
                        items:
                            tip.map<DropdownMenuItem<String>>((String value) {
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
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 30,
                  width: 460,
                  child: Text('SLIKA'),
                ),
              )
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  //_pickImage();
                  uploadImage();
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: _incrementEnter,
                  onHover: _updateLocation,
                  onExit: _incrementExit,
                  child: Container(
                      height: 100,
                      width: 100,
                      color: color,
                      child: picked == false
                          ? ImageIcon(
                              AssetImage('lib/sredstva/addimage.png'),
                              color: Colors.grey,
                            )
                          : Image.network(urldata)),
                ),
              )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 150, height: 50),
            child: ElevatedButton(
              onPressed: () {
                List<Predmet> accounts = [];
                var db = FirebaseFirestore.instance;
                String ID = box.get('email');
                final docRef = db.collection("Users").doc(ID);
                docRef.get().then((DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  List<dynamic> accountsJson = data['predmeti'];

                  for (int i = 0; i < accountsJson.length; i++) {
                    Map<String, dynamic> valueMap =
                        json.decode(accountsJson[i]);
                    Predmet NewAccount = Predmet.fromJson(valueMap);
                    accounts.add(NewAccount);
                  }
                  var uuid = Uuid();
                  bool slika = false;
                  if (file != null) {
                    slika = true;
                  }
                  Predmet kon = Predmet(
                      ID: uuid.v1(),
                      ime: _imeController.text.trim(),
                      kolicina: _kolicinaController.text.trim(),
                      enota: dropdownValue,
                      slika: slika,
                      bilanca: _bilancaController.text.trim(),
                      tip: dropdownValue2,
                      kont: izbraniKont);

                  String ID = box.get('email');
                  storage.uploadFile(file, _imeController.text.trim(), ID);
                  accounts.add(kon);
                  List<String> kontiJson = [];
                  for (int i = 0; i < accounts.length; i++) {
                    kontiJson.add(jsonEncode(accounts[i]));
                  }
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(ID)
                      .update({'predmeti': kontiJson});
                }, onError: (e) => print("Error getting document: $e"));
              },
              child: Text('Dodaj'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                  textStyle: MaterialStateProperty.all(const TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                      color: Colors.white))),
            ),
          )
        ],
      ),
    );
  }
}
