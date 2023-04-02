import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'add_projekt_form.dart';

class AddProjektButton extends StatefulWidget {
  const AddProjektButton({super.key});

  @override
  State<AddProjektButton> createState() => _AddProjektButtonState();
}

class _AddProjektButtonState extends State<AddProjektButton> {
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
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(content: AddProjektForm());
            });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: _incrementEnter,
        onHover: _updateLocation,
        onExit: _incrementExit,
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: Color(0xEEEEEEEE),
              ),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Center(
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xEEEEEEEE),
                  ),
                  color: color,
                  shape: BoxShape.circle),
              child: Center(
                child: Container(
                  width: 30,
                  height: 30,
                  child: ImageIcon(
                    AssetImage('lib/sredstva/plus.png'),
                    color: Color(0xEEEEEEEE),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
