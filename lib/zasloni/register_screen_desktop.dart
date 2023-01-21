import 'package:accounting_app/zasloni/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegisterScreenDesktop extends StatefulWidget {
  const RegisterScreenDesktop({super.key});

  @override
  State<RegisterScreenDesktop> createState() => _RegisterScreenDesktopState();
}

class _RegisterScreenDesktopState extends State<RegisterScreenDesktop> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool showRed = false;

  Future signUp() async {
    if (passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      showRed = true;
      setState(() {});
    }
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
        Container(
          width: 640,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(100, 220, 100, 0),
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
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/sredstva/logo_centered.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
