import 'package:accounting_app/objekti/produkt_storitev.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProduktStoritevRowMobile extends StatefulWidget {
  const ProduktStoritevRowMobile({super.key, required this.produktStoritev});
  final ProduktStoritev produktStoritev;

  @override
  State<ProduktStoritevRowMobile> createState() =>
      _ProduktStoritevRowMobileState();
}

class _ProduktStoritevRowMobileState extends State<ProduktStoritevRowMobile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Ime',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.produktStoritev.naziv,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Tip',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.produktStoritev.PS,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Cena',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.produktStoritev.cena,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Število prodaj',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.produktStoritev.prodaja,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Bilanca',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.produktStoritev.bilanca,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
