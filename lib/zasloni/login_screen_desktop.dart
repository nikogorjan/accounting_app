//import 'dart:html';

import 'package:accounting_app/zasloni/screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:accounting_app/data/data.dart';

class LoginScreenDesktop extends StatefulWidget {
  const LoginScreenDesktop({super.key});

  @override
  State<LoginScreenDesktop> createState() => _LoginScreenDesktopState();
}

class _LoginScreenDesktopState extends State<LoginScreenDesktop> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    //global.email = _emailController.text.trim();
    box.put('email', _emailController.text.trim());

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            padding: const EdgeInsets.fromLTRB(0, 220, 100, 0),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dobrodošli nazaj!",
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
                      height: 40,
                    ),
                    SizedBox(
                      width: 460,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: signIn,
                        child: Text(
                          "Vpis",
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
                          'Niste član?',
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
                                      builder: (context) =>
                                          const RegisterScreen()));
                            },
                            child: Text(
                              'Registracija',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'OpenSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
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
