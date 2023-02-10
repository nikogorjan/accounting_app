import 'package:accounting_app/gradniki/banka/add_bank_button.dart';
import 'package:accounting_app/gradniki/banka/bank_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../data/data.dart';

class BankaDesktop extends StatefulWidget {
  const BankaDesktop({super.key});

  @override
  State<BankaDesktop> createState() => _BankaDesktopState();
}

class _BankaDesktopState extends State<BankaDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                'Banka',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 36),
              ),
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
                    onPressed: () {},
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
            child: Divider(
              height: 20,
            ),
          ),
          Row(
            children: [
              AddBankButton(),
              SizedBox(
                width: 20,
              ),
              BankCard()
            ],
          )
        ],
      ),
    );
  }
}
