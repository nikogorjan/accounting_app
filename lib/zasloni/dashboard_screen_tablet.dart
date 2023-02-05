import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class DashboardScreenTablet extends StatefulWidget {
  const DashboardScreenTablet({super.key});

  @override
  State<DashboardScreenTablet> createState() => _DashboardScreenTabletState();
}

class _DashboardScreenTabletState extends State<DashboardScreenTablet> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 370,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.all(15),
              width: 300,
              color: Color(0xEEEEEEEE).withOpacity(0.5),
            ),
          ],
        ),
        Expanded(
          child: Container(
            //padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                //Flexible(flex: 2, child: Container()),
                Expanded(
                  child: Container(
                    //width: 820,
                    child: ListView(
                      //padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                      children: [
                        Container(
                          width: 100,
                          height: 50,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Spacer(),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                    },
                                    child: Text('izpis')),
                              ),
                            ],
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
                                      color: Colors.black,
                                    )
                                  ],
                                )),
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
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
                //Flexible(flex: 2, child: Container()),
              ],
            ),
          ),
        )
      ],
    );
  }
}
