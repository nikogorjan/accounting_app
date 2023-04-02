import 'package:accounting_app/gradniki/stroski/storitve.dart';
import 'package:accounting_app/gradniki/stroski/stroski_racuni.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../data/data.dart';
import 'dobavitelji.dart';

class StroskiDesktop extends StatefulWidget {
  const StroskiDesktop({super.key});

  @override
  State<StroskiDesktop> createState() => _StroskiDesktopState();
}

class _StroskiDesktopState extends State<StroskiDesktop> {
  List<Widget> GKmenu = [StroskiRacuni(), Dobavitelji(), Storitve()];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Stroški',
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 36),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                height: 50,
                child: TextButton(
                    onPressed: () {
                      global.stroskiIndex.value = 0;
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Računi',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 24,
                              color: Colors.black)),
                    )),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                height: 50,
                child: TextButton(
                    onPressed: () {
                      global.stroskiIndex.value = 1;
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Dobavitelji',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 24,
                              color: Colors.black)),
                    )),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                height: 50,
                child: TextButton(
                    onPressed: () {
                      global.stroskiIndex.value = 2;
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Storitve',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 24,
                              color: Colors.black)),
                    )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
            child: Divider(
              height: 20,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: global.stroskiIndex,
            builder: ((context, value, child) {
              return GKmenu[global.stroskiIndex.value];
            }),
          ),
        ],
      ),
    );
  }
}
