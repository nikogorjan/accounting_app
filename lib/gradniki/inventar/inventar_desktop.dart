import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class InventarDesktop extends StatefulWidget {
  const InventarDesktop({super.key});

  @override
  State<InventarDesktop> createState() => _InventarDesktopState();
}

class _InventarDesktopState extends State<InventarDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('inventarDESKTOP'),
    );
  }
}
