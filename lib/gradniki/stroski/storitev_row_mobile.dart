import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../objekti/storitev.dart';

class StoritevRowMobile extends StatefulWidget {
  const StoritevRowMobile({super.key, required this.storitev});
  final Storitev storitev;

  @override
  State<StoritevRowMobile> createState() => _StoritevRowMobileState();
}

class _StoritevRowMobileState extends State<StoritevRowMobile> {
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
                widget.storitev.ime,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Dobavitelj',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.storitev.dobavitelj,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Komentar',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.storitev.komentar,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Število nakupov',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
              Spacer(),
              Text(
                widget.storitev.stnakupov,
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
                widget.storitev.bilanca,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
