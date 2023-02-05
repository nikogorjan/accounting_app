import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Dnevnik extends StatefulWidget {
  const Dnevnik({super.key});

  @override
  State<Dnevnik> createState() => _DnevnikState();
}

class _DnevnikState extends State<Dnevnik> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Dnevnik'),
    );
  }
}
