import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:accounting_app/data/data.dart';

class MenuNavigation extends StatefulWidget {
  const MenuNavigation({super.key});

  @override
  State<MenuNavigation> createState() => _MenuNavigationState();
}

class _MenuNavigationState extends State<MenuNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
          ),
          Container(
            width: 300,
            height: 50,
            //color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  global.menuIndex.value = 0;
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('lib/sredstva/dashboard.png'),
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Nadzorna plošča',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Container(
            width: 300,
            height: 50,
            //color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  global.menuIndex.value = 1;
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('lib/sredstva/banka.png'),
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Banka',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Container(
            width: 300,
            height: 50,
            //color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  global.menuIndex.value = 2;
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('lib/sredstva/prodaja.png'),
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Prodaja',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Container(
            width: 300,
            height: 50,
            //color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  global.menuIndex.value = 3;
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('lib/sredstva/stroski.png'),
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Stroški',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Container(
            width: 300,
            height: 50,
            //color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  global.menuIndex.value = 4;
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('lib/sredstva/delavci.png'),
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Delavci',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Container(
            width: 300,
            height: 50,
            //color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  global.menuIndex.value = 5;
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('lib/sredstva/porocila.png'),
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Poročila',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Container(
            width: 300,
            height: 50,
            //color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  global.menuIndex.value = 6;
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('lib/sredstva/inventar.png'),
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Inventar',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Container(
            width: 300,
            height: 50,
            //color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  global.menuIndex.value = 7;
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('lib/sredstva/projekti.png'),
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Projekti',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Container(
            width: 300,
            height: 50,
            //color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  global.menuIndex.value = 8;
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('lib/sredstva/glavna_knjiga.png'),
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Glavna knjiga',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: 300,
            height: 50,
            //color: Colors.blue,
            child: TextButton(
                onPressed: () {
                  box.delete('email');
                  FirebaseAuth.instance.signOut();
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('lib/sredstva/logout.png'),
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Odjava',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
