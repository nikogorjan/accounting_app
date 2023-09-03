import 'package:accounting_app/gradniki/prodaja/produkt_form.dart';
import 'package:accounting_app/gradniki/prodaja/storitev_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProduktStoritevForm extends StatefulWidget {
  const ProduktStoritevForm({super.key});

  @override
  State<ProduktStoritevForm> createState() => _ProduktStoritevFormState();
}

class _ProduktStoritevFormState extends State<ProduktStoritevForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: 500,
      height: 340,
      child: Column(
        children: [
          SizedBox(
            height: 0,
          ),
          Divider(),
          Container(
            height: 100,
            child: TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: ((context) => AlertDialog(
                            title: Text(''),
                            content: ProduktForm(),
                          )));
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Produkt',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 24,
                          color: Colors.black)),
                )),
          ),
          Divider(),
          Container(
            height: 100,
            child: TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: ((context) => AlertDialog(
                            title: Text(''),
                            content: StoritevForm(),
                          )));
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Storitev',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 24,
                          color: Colors.black)),
                )),
          ),
          Divider()
        ],
      ),
    );
  }
}
