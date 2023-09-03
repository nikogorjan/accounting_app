import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../data/data.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        //padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Row(
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
            onTap: () {
              global.menuIndex.value = 0;
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            title: Row(
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
            onTap: () {
              global.menuIndex.value = 1;
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            title: Row(
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
            onTap: () {
              global.menuIndex.value = 2;
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            title: Row(
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
            onTap: () {
              global.menuIndex.value = 3;
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            title: Row(
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
            onTap: () {
              global.menuIndex.value = 4;
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            title: Row(
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
            onTap: () {
              global.menuIndex.value = 5;
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            title: Row(
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
            onTap: () {
              global.menuIndex.value = 6;
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            title: Row(
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
            onTap: () {
              global.menuIndex.value = 7;
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            title: Row(
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
            onTap: () {
              global.menuIndex.value = 8;
              Scaffold.of(context).closeDrawer();
            },
          ),
          SizedBox(
            height: 40,
          ),
          ListTile(
            title: Row(
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
            onTap: () {
              Scaffold.of(context).closeDrawer();
              box.delete('email');
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
