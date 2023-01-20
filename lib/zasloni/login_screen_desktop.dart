import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginScreenDesktop extends StatefulWidget {
  const LoginScreenDesktop({super.key});

  @override
  State<LoginScreenDesktop> createState() => _LoginScreenDesktopState();
}

class _LoginScreenDesktopState extends State<LoginScreenDesktop> {
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
                        onPressed: () {},
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
                            onPressed: () {},
                            child: Text(
                              'Registracija',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'OpenSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
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
