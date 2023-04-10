import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AccountRowMobile extends StatefulWidget {
  const AccountRowMobile(
      {super.key,
      required this.ID,
      required this.ime,
      required this.tip,
      required this.podtip,
      required this.bilanca,
      required this.amortizacija});
  final String ID;
  final String ime;
  final String tip;
  final String podtip;
  final String bilanca;
  final String amortizacija;

  @override
  State<AccountRowMobile> createState() => _AccountRowMobileState();
}

class _AccountRowMobileState extends State<AccountRowMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'ID',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
              Spacer(),
              Text(
                widget.ID,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                'Ime',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
              Spacer(),
              Text(
                widget.ime,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                'Tip',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
              Spacer(),
              Text(
                widget.tip,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                'Podtip',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
              Spacer(),
              Text(
                widget.podtip,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                'Bilanca',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
              Spacer(),
              Text(
                double.parse(widget.bilanca).abs().toStringAsFixed(2),
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
