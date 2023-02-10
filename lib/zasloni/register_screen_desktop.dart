import 'dart:convert';

import 'package:accounting_app/data/vnosi_v_dnevnik.dart';
import 'package:accounting_app/zasloni/screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:accounting_app/data/konti.dart';
import 'package:accounting_app/data/data.dart';

class RegisterScreenDesktop extends StatefulWidget {
  const RegisterScreenDesktop({super.key});

  @override
  State<RegisterScreenDesktop> createState() => _RegisterScreenDesktopState();
}

class _RegisterScreenDesktopState extends State<RegisterScreenDesktop> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _imeController = TextEditingController();
  final _priimekController = TextEditingController();
  final _telController = TextEditingController();
  final _nazivController = TextEditingController();

  bool showRed = false;

  Future signUp() async {
    //global.email = _emailController.text.trim();
    box.put('email', _emailController.text.trim());

    if (passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));

      //add details
      addUserDetails(
          _imeController.text.trim(),
          _priimekController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _telController.text.trim(),
          _nazivController.text.trim());
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
    global.id = id;
    users.doc(id).set({
      "email": email,
      "geslo": geslo,
      "ime": ime,
      "priimek": priimek,
      'telefonska stevilka': telst,
      'naziv podjetja': naziv,
      'id': id,
      'konti': [
        jsonEncode(konti[0]),
        jsonEncode(konti[1]),
        jsonEncode(konti[2])
      ],
      'vnosi v dnevnik': [],
      'banka': [],
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
    return Row(
      children: [
        Flexible(
            //flex: 1,
            child: Container(
          width: 380,
          color: Colors.white,
        )),
        Container(
          width: 460,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 100, 0),
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
                          fontSize: 40),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Text(
                      'Nadgradite vašo kariero.',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Color(0xA4A3A3A4),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'E-naslov',
                          hintStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Color(0xA4A3A3A4),
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Geslo',
                          hintStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Color(0xA4A3A3A4),
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Ponovi geslo',
                          hintStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Color(0xA4A3A3A4),
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _imeController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Ime',
                          hintStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Color(0xA4A3A3A4),
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _priimekController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Priimek',
                          hintStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Color(0xA4A3A3A4),
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _telController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Telefonska številka',
                          hintStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Color(0xA4A3A3A4),
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _nazivController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Naziv podjetja',
                          hintStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Color(0xA4A3A3A4),
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    SizedBox(
                      height: 40,
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
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Že imate račun?',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16,
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
                                  fontSize: 16,
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
        ),
        Flexible(
          flex: 3,
          child: Container(
            width: 1080, //double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/sredstva/hotpot.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
