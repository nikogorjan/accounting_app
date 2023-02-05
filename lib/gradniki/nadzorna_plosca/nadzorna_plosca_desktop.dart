import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NadzornaPloscaDesktop extends StatefulWidget {
  const NadzornaPloscaDesktop({super.key});

  @override
  State<NadzornaPloscaDesktop> createState() => _NadzornaPloscaDesktopState();
}

class _NadzornaPloscaDesktopState extends State<NadzornaPloscaDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                'Nadzorna plošča',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 36),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Colors.black,
                      )
                    ],
                  )),
              SizedBox(
                width: 20,
                child: Container(
                  color: Colors.white,
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Color(0xEEEEEEEE).withOpacity(0.5),
                      )
                    ],
                  )),
              SizedBox(
                width: 20,
                child: Container(
                  color: Colors.white,
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Color(0xEEEEEEEE).withOpacity(0.5),
                      )
                    ],
                  ))
            ],
          ),
          SizedBox(
            height: 20,
            child: Container(
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Color(0xEEEEEEEE).withOpacity(0.5),
                      )
                    ],
                  )),
              SizedBox(
                width: 20,
              ),
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Color(0xEEEEEEEE).withOpacity(0.5),
                      )
                    ],
                  )),
              SizedBox(
                width: 20,
              ),
              Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        color: Color(0xEEEEEEEE).withOpacity(0.5),
                      )
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
