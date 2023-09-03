import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../data/data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../objekti/kont.dart';
import '../../../objekti/vnos_v_dnevnik.dart';
import 'package:intl/intl.dart';

class OdhodkiGraf extends StatefulWidget {
  const OdhodkiGraf({super.key});

  @override
  State<OdhodkiGraf> createState() => _OdhodkiGrafState();
}

List<String> list = <String>[
  'Zadnjih 30 dni',
  'Zadnja 2 meseca',
  'Zadnje 3 mesece',
  'Zadnjih 6 mesecev',
  'Zadnjih 365 dni'
];

class _OdhodkiGrafState extends State<OdhodkiGraf> {
  String dropdownValue = list.first;
  String time = '';

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isEqualTo: box.get('email'))
      .snapshots();

  List<Kont> prihodki = [];
  List<Kont> odhodki = [];

  bool isLessThanDaysApart(DateTime date1, DateTime date2, int days) {
    final difference = date2.difference(date1).inDays.abs();
    return difference <= days;
  }

  void setTimedValues(List<Kont> konti, List<VnosVDnevnik> vnosi, int days) {
    for (int i = 0; i < vnosi.length; i++) {
      for (int j = 0; j < konti.length; j++) {
        if (isLessThanDaysApart(
            DateTime.now(), DateTime.parse(vnosi[i].datum), days)) {
          if (konti[j].ime == vnosi[i].kontDebet) {
            Kont old = konti[j];
            konti[j] = Kont(
                ID: old.ID,
                ime: old.ime,
                tip: old.tip,
                podtip: old.podtip,
                bilanca:
                    (double.parse(vnosi[i].debet) + double.parse(old.bilanca))
                        .toString(),
                amortizacija: old.amortizacija,
                bilancaDate: old.bilancaDate,
                amortizacijaDate: old.amortizacijaDate,
                debet: (double.parse(vnosi[i].debet) + double.parse(old.debet))
                    .toString(),
                kredit: old.kredit);
          } else if (konti[j].ime == vnosi[i].kontKredit) {
            Kont old = konti[j];
            konti[j] = Kont(
                ID: old.ID,
                ime: old.ime,
                tip: old.tip,
                podtip: old.podtip,
                bilanca:
                    (double.parse(old.bilanca) - double.parse(vnosi[i].kredit))
                        .toString(),
                amortizacija: old.amortizacija,
                bilancaDate: old.bilancaDate,
                amortizacijaDate: old.amortizacijaDate,
                debet: old.debet,
                kredit:
                    (double.parse(vnosi[i].kredit) + double.parse(old.kredit))
                        .toString());
          }
        }
      }
    }
  }

  void sortAccounts(List<Kont> konti, int days) {
    for (int i = 0; i < konti.length; i++) {
      if (konti[i].tip == 'Prihodki') {
        prihodki.add(konti[i]);
      } else if (konti[i].tip == 'Odhodki') {
        odhodki.add(konti[i]);
      }
    }
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
                'STROŠKI',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'OpenSans', fontSize: 24),
              ),
            ],
          ),
          Divider(
            color: Colors.black,
          ),
          Row(
            children: [
              Container(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  //icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(
                      color: Colors.black, fontFamily: 'OpenSans'),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
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

                  List<dynamic> kontiJson = data['konti'];
                  List<Kont> konti = [];
                  List<dynamic> vnosiJson = data['vnosi v dnevnik'];
                  List<VnosVDnevnik> vnosi = [];

                  for (int i = 0; i < kontiJson.length; i++) {
                    Map<String, dynamic> valueMap = json.decode(kontiJson[i]);
                    Kont NewAccount = Kont.fromJson(valueMap);
                    konti.add(NewAccount);
                  }

                  for (int i = 0; i < vnosiJson.length; i++) {
                    Map<String, dynamic> valueMap = json.decode(vnosiJson[i]);
                    VnosVDnevnik NewAccount = VnosVDnevnik.fromJson(valueMap);
                    vnosi.add(NewAccount);
                  }

                  int stDni = 0;

                  if (dropdownValue == 'Zadnjih 30 dni') {
                    stDni = 30;
                  } else if (dropdownValue == 'Zadnja 2 meseca') {
                    stDni = 60;
                  } else if (dropdownValue == 'Zadnje 3 mesece') {
                    stDni = 90;
                  } else if (dropdownValue == 'Zadnjih 6 mesecev') {
                    stDni = 180;
                  } else if (dropdownValue == 'Zadnjih 365 dni') {
                    stDni = 365;
                  }

                  prihodki.clear();
                  odhodki.clear();
                  for (int i = 0; i < konti.length; i++) {
                    Kont old = konti[i];
                    konti[i] = Kont(
                        ID: old.ID,
                        ime: old.ime,
                        tip: old.tip,
                        podtip: old.podtip,
                        bilanca: '0',
                        amortizacija: old.amortizacija,
                        bilancaDate: old.bilancaDate,
                        amortizacijaDate: old.amortizacijaDate,
                        debet: '0',
                        kredit: '0');
                  }

                  setTimedValues(konti, vnosi, stDni);

                  sortAccounts(konti, stDni);

                  double retainedValue = 0;
                  double prihodkiVal = 0;
                  double odhodkiVal = 0;
                  for (int i = 0; i < prihodki.length; i++) {
                    retainedValue += double.parse(prihodki[i].bilanca).abs();
                    prihodkiVal += double.parse(prihodki[i].bilanca).abs();
                  }
                  for (int j = 0; j < odhodki.length; j++) {
                    retainedValue -= double.parse(odhodki[j].bilanca).abs();
                    odhodkiVal += double.parse(odhodki[j].bilanca).abs();
                  }

                  List<ChartData> dataa = [];

                  /*int red = 222;
                  int green = 255;
                  int blue = 177;*/

                  int red = 151;
                  int green = 234;
                  int blue = 137;

                  for (int i = 0; i < odhodki.length; i++) {
                    dataa.add(ChartData(
                        odhodki[i].ime,
                        double.parse(odhodki[i].bilanca).abs(),
                        Color.fromRGBO(red, green, blue, 1),
                        0));
                    red = red - 20;
                    green = green - 20;
                  }

                  for (int i = 0; i < dataa.length; i++) {
                    ChartData old = dataa[i];
                    dataa[i] = ChartData(old.x, old.y, old.color,
                        ((old.percent) / odhodkiVal) * 100);
                  }

                  double max = 0;
                  if (prihodkiVal > odhodkiVal) {
                    max = prihodkiVal;
                  } else {
                    max = odhodkiVal;
                  }

                  //debetItem = dropdownValue;
                  return SizedBox(
                      height: 220,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Stroški skupaj',
                                style: TextStyle(
                                    fontFamily: 'OpenSans', fontSize: 18),
                              ),
                              Spacer(),
                              Text(
                                '€' + odhodkiVal.toStringAsFixed(2),
                                style: TextStyle(
                                    fontFamily: 'OpenSans', fontSize: 18),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 170,
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
                                        pointColorMapper:
                                            (ChartData dataa, _) => dataa.color,
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
                                            double percentage =
                                                (point.y / odhodkiVal) * 100;
                                            return Text(
                                              '${point.y}€ (${percentage.toStringAsFixed(2)}%)',
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
          /*Container(
              height: 170,
              child: SfCircularChart(series: <CircularSeries>[
                // Render pie chart
                PieSeries<ChartData, String>(
                  dataSource: chartData,
                  pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
                  ),
                )
              ]))*/
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color, this.percent);
  final String x;
  final double y;
  final double percent;
  final Color color;

  String get yAsPercentage => NumberFormat.percentPattern().format(y / 100);
}
