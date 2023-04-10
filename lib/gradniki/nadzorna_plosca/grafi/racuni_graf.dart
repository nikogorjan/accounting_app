import 'dart:convert';

import 'package:accounting_app/gradniki/prodaja/prodaja_racun_row.dart';
import 'package:accounting_app/objekti/prodaja.dart';
import 'package:accounting_app/objekti/racun_prodaja.dart';
import 'package:accounting_app/objekti/racun_strosek.dart';
import 'package:accounting_app/objekti/strosek.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../data/data.dart';

class RacuniGraf extends StatefulWidget {
  const RacuniGraf({super.key});

  @override
  State<RacuniGraf> createState() => _RacuniGrafState();
}

class _RacuniGrafState extends State<RacuniGraf> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(children: [
        Row(
          children: [
            Text(
              'RAČUNI',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'OpenSans', fontSize: 24),
            ),
          ],
        ),
        Divider(
          color: Colors.black,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                List<dynamic> prodajaJson = data['prodaja'];
                List<RacunProdaja> prodaja = [];
                List<dynamic> stroskiJson = data['stroski'];
                List<RacunStrosek> stroski = [];

                for (int i = 0; i < prodajaJson.length; i++) {
                  Map<String, dynamic> valueMap = json.decode(prodajaJson[i]);
                  RacunProdaja NewAccount = RacunProdaja.fromJson(valueMap);
                  prodaja.add(NewAccount);
                }

                for (int i = 0; i < stroskiJson.length; i++) {
                  Map<String, dynamic> valueMap = json.decode(stroskiJson[i]);
                  RacunStrosek NewAccount = RacunStrosek.fromJson(valueMap);
                  stroski.add(NewAccount);
                }

                double prodajaPlacani = 0;
                double prodajaNeplacani = 0;
                double stroskiPlacani = 0;
                double stroskiNeplacani = 0;
                for (int i = 0; i < prodaja.length; i++) {
                  if (prodaja[i].placan == true) {
                    prodajaPlacani += 1;
                  } else {
                    prodajaNeplacani += 1;
                  }
                }

                for (int i = 0; i < stroski.length; i++) {
                  if (stroski[i].placan == true) {
                    stroskiPlacani += 1;
                  } else {
                    stroskiNeplacani += 1;
                  }
                }
                List<ChartData> dataa = [
                  ChartData('Prejeti plačani', stroskiPlacani,
                      Color.fromRGBO(151, 234, 137, 1)),
                  ChartData('Prejeti neplačani', stroskiNeplacani,
                      Color.fromRGBO(214, 123, 123, 1)),
                  ChartData('Izdani plačani', prodajaPlacani,
                      Color.fromRGBO(121, 234, 97, 1)),
                  ChartData('Izdani neplačani', prodajaNeplacani,
                      Color.fromRGBO(214, 93, 93, 1))
                ];

                //debetItem = dropdownValue;
                return SizedBox(
                    height: 265,
                    child: Column(
                      children: [
                        Container(
                            height: 265,
                            child: SfCircularChart(
                                tooltipBehavior: TooltipBehavior(
                                    enable: true,
                                    builder: (dynamic data,
                                        dynamic point,
                                        dynamic series,
                                        int pointIndex,
                                        int seriesIndex) {
                                      return Container(
                                        height: 22,
                                        padding: EdgeInsets.all(2),
                                        child: Text(
                                          '${point.x}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'OpenSans'),
                                        ),
                                      );
                                    }),
                                series: <CircularSeries>[
                                  // Render pie chart
                                  PieSeries<ChartData, String>(
                                      dataSource: dataa,
                                      pointColorMapper: (ChartData dataa, _) =>
                                          dataa.color,
                                      xValueMapper: (ChartData dataa, _) =>
                                          dataa.x,
                                      yValueMapper: (ChartData dataa, _) =>
                                          dataa.y,
                                      dataLabelSettings: DataLabelSettings(
                                        labelPosition:
                                            ChartDataLabelPosition.outside,
                                        labelAlignment:
                                            ChartDataLabelAlignment.middle,
                                        builder: (dynamic data,
                                            dynamic point,
                                            dynamic series,
                                            int pointIndex,
                                            int seriesIndex) {
                                          return Text(
                                            '${point.y}',
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontFamily: 'OpenSans'),
                                          );
                                        },
                                        isVisible: true,
                                      ))
                                ]))
                      ],
                    ));
              }).toList(),
            );
          },
        )
      ]),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;

  final Color color;
}
