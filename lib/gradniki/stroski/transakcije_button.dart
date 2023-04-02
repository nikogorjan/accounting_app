import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TransakcijeButton extends StatefulWidget {
  const TransakcijeButton({super.key});

  @override
  State<TransakcijeButton> createState() => _TransakcijeButtonState();
}

class _TransakcijeButtonState extends State<TransakcijeButton> {
  Color color = Colors.white;
  int _enterCounter = 0;
  int _exitCounter = 0;
  double x = 0.0;
  double y = 0.0;

  void _incrementEnter(PointerEvent details) {
    setState(() {
      _enterCounter++;
    });
  }

  void _incrementExit(PointerEvent details) {
    setState(() {
      color = Colors.white;
      _exitCounter++;
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      color = Color.fromRGBO(217, 234, 250, 0.2);
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: MouseRegion(
        onEnter: _incrementEnter,
        onHover: _updateLocation,
        onExit: _incrementExit,
        child: Container(
          width: 30,
          height: 30,
          color: color,
          child: ImageIcon(
            AssetImage('lib/sredstva/transakcije.png'),
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
