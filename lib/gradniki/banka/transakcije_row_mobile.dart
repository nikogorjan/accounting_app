import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../objekti/transakcija.dart';

class TransakcijeRowMobile extends StatefulWidget {
  const TransakcijeRowMobile({super.key, required this.transakcija});
  final Transakcija transakcija;

  @override
  State<TransakcijeRowMobile> createState() => _TransakcijeRowMobileState();
}

class _TransakcijeRowMobileState extends State<TransakcijeRowMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Datum',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
              Spacer(),
              Text(
                "${DateTime.parse(widget.transakcija.datum).day}. ${DateTime.parse(widget.transakcija.datum).month}. ${DateTime.parse(widget.transakcija.datum).year}",
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
                'Prejemnik/Plačnik',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
              Spacer(),
              Text(
                widget.transakcija.prejemnikPlacila,
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
                'Kont',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
              Spacer(),
              Text(
                widget.transakcija.kont,
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
                'Prejeto',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
              Spacer(),
              Text(
                widget.transakcija.prejeto,
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
                'Plačilo',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                ),
              ),
              Spacer(),
              Text(
                widget.transakcija.placilo,
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
