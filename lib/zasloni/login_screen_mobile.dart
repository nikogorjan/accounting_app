import 'package:accounting_app/zasloni/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginScreenMobile extends StatefulWidget {
  LoginScreenMobile({super.key});

  @override
  State<LoginScreenMobile> createState() => _LoginScreenMobileState();
}

class _LoginScreenMobileState extends State<LoginScreenMobile> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  Future signIn() async {
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
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 120, 50, 0),
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
                  height: 80,
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
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      'Niste član?',
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
                                  builder: (context) =>
                                      const RegisterScreen()));
                        },
                        child: Text(
                          'Registracija',
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'OpenSans',
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
