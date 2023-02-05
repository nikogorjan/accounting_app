import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BankaDesktop extends StatefulWidget {
  const BankaDesktop({super.key});

  @override
  State<BankaDesktop> createState() => _BankaDesktopState();
}

class _BankaDesktopState extends State<BankaDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('BANKADESKTOP'),
    );
  }
}
