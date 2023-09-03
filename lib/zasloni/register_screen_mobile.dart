import 'dart:io';
import 'dart:typed_data';

import 'package:accounting_app/zasloni/screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:accounting_app/data/data.dart';
import 'package:universal_html/html.dart' as html;

import '../services/storage_service.dart';

class RegisterScreenMobile extends StatefulWidget {
  const RegisterScreenMobile({super.key});

  @override
  State<RegisterScreenMobile> createState() => _RegisterScreenMobileState();
}

class _RegisterScreenMobileState extends State<RegisterScreenMobile> {
  final Storage storage = Storage();

  Uint8List webImage = Uint8List(8);
  File? _pickedImage;
  String imagePath = '';
  String imageName = '';
  bool picked = false;

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

  String urldata = '';
  late final file;
  late final reader;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _imeController = TextEditingController();
  final _priimekController = TextEditingController();
  final _telController = TextEditingController();
  final _nazivController = TextEditingController();

  bool showRed = false;

  void uploadImage() {
    //String ID = box.get('email');
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

  late String path;
  late String fileName;

  bool picked2 = false;

  void pickFileMobile() async {
    String paath;
    String naame;
    final results = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);

    if (results == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nobena datoteka ni bila izbrana.')));
      return null;
    }

    path = results.files.single.path!;
    fileName = results.files.single.name;

    print(path);
    print(fileName);
    picked2 = true;
  }

  Future signUp() async {
    //global.email = _emailController.text.trim();
    box.put('email', _emailController.text.trim());

    if (passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));

      addUserDetails(
          _imeController.text.trim(),
          _priimekController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _telController.text.trim(),
          _nazivController.text.trim());

      if (kIsWeb) {
        storage.uploadFile(file, '_Logotip', _emailController.text.trim());
      } else {
        storage.UploadFileMobile(
            path, '_Logotip', _emailController.text.trim());
      }
    } else {
      showRed = true;
      setState(() {});
    }
  }

  Future<void> addUserDetails(String ime, String priimek, String email,
      String geslo, String telst, String naziv) async {
    //String kontiJson = jsonEncode(kontii);
    CollectionReference users =
        await FirebaseFirestore.instance.collection("Users");

    String id = email;
    //global.id = id;
    users.doc(id).set({
      "email": email,
      //"geslo": geslo,
      "ime": ime,
      "naziv podjetja": naziv,
      'telefonska stevilka': telst,
      'sedez podjetja': priimek,
      'id': id,
      'konti': [],
      'vnosi v dnevnik': [],
      'banka': [],
      'dobavitelji': [],
      'predmeti': [],
      'storitve': [],
      'stroski': [],
      'stranke': [],
      'produkti in storitve': [],
      'prodaja': [],
      'projekti': [],
      'planirane storitve': [],
      'zaposleni': [],
      'ure dela': [],
      'place': []
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Registracija!",
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 32),
                ),
                SizedBox(
                  height: 0,
                ),
                Text(
                  'Nadgradite vašo kariero.',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xA4A3A3A4),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 460,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'E-naslov',
                        hintStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Color(0xA4A3A3A4),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 460,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Geslo',
                        hintStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Color(0xA4A3A3A4),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 460,
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Ponovi Geslo',
                        hintStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Color(0xA4A3A3A4),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 460,
                  child: TextFormField(
                    controller: _imeController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Ime in priimek',
                        hintStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Color(0xA4A3A3A4),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 460,
                  child: TextFormField(
                    controller: _priimekController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Sedež podjetja',
                        hintStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Color(0xA4A3A3A4),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 460,
                  child: TextFormField(
                    controller: _telController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Telefonska številka',
                        hintStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Color(0xA4A3A3A4),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 460,
                  child: TextFormField(
                    controller: _nazivController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Naziv podjetja',
                        hintStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Color(0xA4A3A3A4),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (kIsWeb) {
                          uploadImage();
                        } else {
                          pickFileMobile();
                        }
                      },
                      child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: _incrementEnter,
                          onHover: _updateLocation,
                          onExit: _incrementExit,
                          child: kIsWeb == true
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  color: color,
                                  child: picked == false
                                      ? ImageIcon(
                                          AssetImage(
                                              'lib/sredstva/addimage.png'),
                                          color: Colors.grey,
                                        )
                                      : Image.network(urldata))
                              : Container(
                                  height: 100,
                                  width: 100,
                                  color: color,
                                  child: picked2 == false
                                      ? ImageIcon(
                                          AssetImage(
                                              'lib/sredstva/addimage.png'),
                                          color: Colors.grey,
                                        )
                                      : Image.file(File(path)),
                                )),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 460,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: signUp,
                    child: Text(
                      "Registriraj",
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      'Že imate račun?',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xA4A3A3A4),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                        child: Text(
                          'Vpis',
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'OpenSans',
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (showRed)
                  Text(
                    'Gesli se ne ujemata',
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
