import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DelavciDesktop extends StatefulWidget {
  const DelavciDesktop({super.key});

  @override
  State<DelavciDesktop> createState() => _DelavciDesktopState();
}

class _DelavciDesktopState extends State<DelavciDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('delavciESKTOP'),
    );
  }
}
