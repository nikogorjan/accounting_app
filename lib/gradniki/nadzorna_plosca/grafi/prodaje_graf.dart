import 'dart:convert';

import 'package:accounting_app/objekti/produkt_storitev.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../data/data.dart';

class ProdajeGraf extends StatefulWidget {
  const ProdajeGraf({super.key});

  @override
  State<ProdajeGraf> createState() => _ProdajeGrafState();
}

class _ProdajeGrafState extends State<ProdajeGraf> {
  late TooltipBehavior _tooltip;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'PRODAJA',
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

                  List<dynamic> psJson = data['produkti in storitve'];
                  List<ProduktStoritev> ps = [];

                  for (int i = 0; i < psJson.length; i++) {
                    Map<String, dynamic> valueMap = json.decode(psJson[i]);
                    ProduktStoritev NewAccount =
                        ProduktStoritev.fromJson(valueMap);
                    ps.add(NewAccount);
                  }

                  List<_ChartData> dataa = [];

                  int red = 151;
                  int green = 234;
                  int blue = 137;

                  for (int i = 0; i < ps.length; i++) {
                    dataa.add(_ChartData(
                        ps[i].naziv,
                        double.parse(ps[i].prodaja),
                        Color.fromRGBO(red, green, blue, 1)));
                    red = red - 20;
                    green = green - 20;
                  }

                  double max = 0;
                  for (int i = 0; i < dataa.length; i++) {
                    if (dataa[i].y > max) {
                      max = dataa[i].y;
                    }
                  }

                  //debetItem = dropdownValue;
                  return SizedBox(
                      height: 265,
                      child: Column(
                        children: [
                          Container(
                            height: 265,
                            child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: NumericAxis(
                                    minimum: 0, maximum: max, interval: 10),
                                tooltipBehavior: _tooltip,
                                series: <ChartSeries<_ChartData, String>>[
                                  BarSeries<_ChartData, String>(
                                    dataSource: dataa,
                                    xValueMapper: (_ChartData dataa, _) =>
                                        dataa.x,
                                    yValueMapper: (_ChartData dataa, _) =>
                                        dataa.y,
                                    name: 'Število prodaj',
                                    pointColorMapper: (_ChartData dataa, _) =>
                                        dataa.color,
                                  )
                                ]),
                          ),
                        ],
                      ));
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}
