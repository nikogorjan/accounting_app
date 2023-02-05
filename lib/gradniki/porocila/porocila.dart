import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PorocilaDesktop extends StatefulWidget {
  const PorocilaDesktop({super.key});

  @override
  State<PorocilaDesktop> createState() => _PorocilaDesktopState();
}

class _PorocilaDesktopState extends State<PorocilaDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('porocilaDESKTOP'),
    );
  }
}
