import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class StroskiDesktop extends StatefulWidget {
  const StroskiDesktop({super.key});

  @override
  State<StroskiDesktop> createState() => _StroskiDesktopState();
}

class _StroskiDesktopState extends State<StroskiDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('stroski dESKTOP'),
    );
  }
}
