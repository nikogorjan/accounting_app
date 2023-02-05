import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProdajaDesktop extends StatefulWidget {
  const ProdajaDesktop({super.key});

  @override
  State<ProdajaDesktop> createState() => _ProdajaDesktopState();
}

class _ProdajaDesktopState extends State<ProdajaDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('PRODAJA DESKTOP'),
    );
  }
}
