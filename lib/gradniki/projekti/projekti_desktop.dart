import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProjektiDesktop extends StatefulWidget {
  const ProjektiDesktop({super.key});

  @override
  State<ProjektiDesktop> createState() => _ProjektiDesktopState();
}

class _ProjektiDesktopState extends State<ProjektiDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('projektiDESKTOP'),
    );
  }
}
