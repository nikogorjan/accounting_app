import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:accounting_app/gradniki/projekti/vnos_v_projekt.dart';
import 'package:accounting_app/objekti/predmet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import "package:universal_html/html.dart" as html;
import 'package:uuid/uuid.dart';

import '../../data/data.dart';
import '../../objekti/kont.dart';
import '../../objekti/material.dart';
import '../../objekti/plan.dart';
import '../../objekti/projekt.dart';
import '../../services/storage_service.dart';

class AddPlanForm extends StatefulWidget {
  const AddPlanForm({super.key});

  @override
  State<AddPlanForm> createState() => _AddPlanFormState();
}

class _AddPlanFormState extends State<AddPlanForm> {
  final _imeController = TextEditingController();
  List<VnosVProjekt> _children = [];
  List<Materiall> materiali = [];

  void _onChildFormSubmitted(
      int childIndex, String dropdownValue, String textFieldValue1) {
    print(
        'Child Widget ${childIndex + 1} MATERIAL: $dropdownValue KOLICINA: $textFieldValue1');
    materiali[childIndex + 1].ime = dropdownValue;
    materiali[childIndex + 1].kolicina = textFieldValue1;
  }

  Uint8List webImage = Uint8List(8);
  File? _pickedImage;
  String imagePath = '';
  String imageName = '';
  bool picked = false;
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

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  String dropdownValue = '';
  bool changed = false;
  String kontPlaniranja = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 900,
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: 340,
                  height: 30,
                  child: Text(
                    'IME PROJEKTA',
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                ),
                Container(
                  width: 340,
                  height: 30,
                  child: Text(
                    'KONT STROŠKA PRODAJE',
                    style: TextStyle(fontFamily: 'OpenSans'),
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
                  width: 340,
                  height: 50,
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
                ),
                Container(
                  width: 340,
                  height: 50,
                  child: SizedBox(
                    width: 340,
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
                              kontPlaniranja = dropdownValue;
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
                                value: dropdownValue,
                                elevation: 16,
                                style: const TextStyle(fontFamily: 'OpenSans'),
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
                                  kontPlaniranja = dropdownValue;
                                  changed = true;
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: 340,
                  height: 30,
                  child: Text(
                    'MATERIAL',
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                ),
                Container(
                  width: 340,
                  height: 30,
                  child: Text(
                    'KOLIČINA',
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _children.length,
            itemBuilder: (BuildContext context, int index) {
              return _children[index];
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: 150,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 150, height: 50),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(0)),
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              color: Colors.white))),
                      onPressed: () {
                        setState(() {
                          _children.add(
                            VnosVProjekt(
                              onFormSubmitted: _onChildFormSubmitted,
                              index: _children.length - 1,
                            ),
                          );
                          var uuid = Uuid();

                          materiali.add(
                              Materiall(ID: uuid.v1(), ime: '', kolicina: ''));
                        });
                      },
                      child: Text(
                        'DODAJ VRSTICO',
                        style: TextStyle(fontFamily: 'OpenSans'),
                      )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
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
              ),
              Spacer(),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 150, height: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        //dodaj nov predmet v inventar in slike
                        var db = FirebaseFirestore.instance;
                        String ID = box.get('email');
                        final docRef = db.collection("Users").doc(ID);
                        docRef.get().then((DocumentSnapshot doc) {
                          final data = doc.data() as Map<String, dynamic>;

                          final Storage storage = Storage();
                          storage.uploadFile(
                              file, _imeController.text.trim(), ID);

                          List<Predmet> predmeti = [];
                          List<Projekt> projekti = [];
                          List<dynamic> predmetiJson = data['predmeti'];
                          List<dynamic> projektiJson =
                              data['planirane storitve'];

                          for (int i = 0; i < predmetiJson.length; i++) {
                            Map<String, dynamic> valueMap =
                                json.decode(predmetiJson[i]);
                            Predmet NewAccount = Predmet.fromJson(valueMap);
                            predmeti.add(NewAccount);
                          }

                          for (int j = 0; j < projektiJson.length; j++) {
                            Map<String, dynamic> valueMap =
                                json.decode(projektiJson[j]);
                            Projekt NewAccount = Projekt.fromJson(valueMap);
                            projekti.add(NewAccount);
                          }

                          var uuid = Uuid();
                          bool slika = false;
                          if (file != null) {
                            slika = true;
                          }

                          /*Predmet kon = Predmet(
                              ID: uuid.v1(),
                              ime: _imeController.text.trim(),
                              kolicina: '0',
                              enota: '/',
                              slika: slika,
                              bilanca: '0',
                              tip: 'Končni izdelek');*/

                          /*predmeti.add(kon);
                          predmetiJson.add(jsonEncode(kon));
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(ID)
                              .update({'predmeti': predmetiJson});*/

                          List<dynamic> mtr = [];
                          for (int k = 0; k < materiali.length; k++) {
                            mtr.add(jsonEncode(materiali[k]));
                          }

                          Plan plan = Plan(
                              ID: ID,
                              ime: _imeController.text.trim(),
                              slika: slika,
                              material: mtr,
                              kont: kontPlaniranja);

                          /*Projekt pro = Projekt(
                              ID: uuid.v1(),
                              ime: _imeController.text.trim(),
                              slika: slika,
                              material: mtr);*/

                          projektiJson.add(jsonEncode(plan));
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(ID)
                              .update({'planirane storitve': projektiJson});
                        });
                        //dodaj projekt
                      },
                      child: Text('Dodaj'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(0)),
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              color: Colors.white))),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
