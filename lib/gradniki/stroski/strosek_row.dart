import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class StrosekRow extends StatefulWidget {
  const StrosekRow({super.key});

  @override
  State<StrosekRow> createState() => _StrosekRowState();
}

class _StrosekRowState extends State<StrosekRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1500,
      height: 30,
    );
  }
}
