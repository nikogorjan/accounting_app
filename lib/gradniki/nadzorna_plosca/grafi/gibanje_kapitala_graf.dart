import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../data/data.dart';
import '../../../objekti/kont.dart';
import '../../../objekti/vnos_v_dnevnik.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GibanjeKapitala extends StatefulWidget {
  const GibanjeKapitala({super.key});

  @override
  State<GibanjeKapitala> createState() => _GibanjeKapitalaState();
}

List<String> list = <String>[
  'Zadnjih 30 dni',
  'Zadnja 2 meseca',
  'Zadnje 3 mesece',
  'Zadnjih 6 mesecev',
  'Zadnjih 365 dni'
];

class _GibanjeKapitalaState extends State<GibanjeKapitala> {
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

  void deleteVnosi(List<VnosVDnevnik> vnosi, int days) {
    for (int i = 0; i < vnosi.length; i++) {
      if (!isLessThanDaysApart(
          DateTime.parse(vnosi[i].datum), DateTime.now(), days)) {
        vnosi.removeAt(i);
      }
    }
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

  final List<SalesData> chartData = [
    SalesData(DateTime.now(), 35),
    SalesData(DateTime.now(), 28),
    SalesData(DateTime.now(), 34),
    SalesData(DateTime.now(), 32),
    SalesData(DateTime.now(), 40)
  ];

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void buildGraph(List<SalesData> data, List<VnosVDnevnik> prihodki,
      List<VnosVDnevnik> odhodki) {
    bool same = false;
    int index = 0;
    for (int i = 0; i < prihodki.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (isSameDay(DateTime.parse(prihodki[i].datum), data[j].year)) {
          same = true;
          index = j;
        }
      }
      if (same == true) {
        data[index].sales += double.parse(prihodki[i].debet);
      } else {
        data.add(SalesData(DateTime.parse(prihodki[i].datum).toUtc(),
            double.parse(prihodki[i].debet)));
      }
      same = false;
    }

    bool same2 = false;
    int index2 = 0;

    for (int i = 0; i < odhodki.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (isSameDay(DateTime.parse(odhodki[i].datum), data[j].year)) {
          same2 = true;
          index2 = j;
        }
      }
      if (same2 == true) {
        data[index2].sales -= double.parse(odhodki[i].debet);
      } else {
        data.add(SalesData(DateTime.parse(odhodki[i].datum).toUtc(),
            0 - double.parse(odhodki[i].debet)));
      }
      same2 = false;
    }
  }

  List<SalesData> fillDateGaps(List<SalesData> dates) {
    List<SalesData> filledDates = [];
    for (int i = 0; i < dates.length - 1; i++) {
      filledDates.add(dates[i]);
      DateTime currentDate = dates[i].year;
      DateTime nextDate = dates[i + 1].year;
      int difference = nextDate.difference(currentDate).inDays;
      if (difference > 1) {
        for (int j = 1; j < difference; j++) {
          filledDates.add(SalesData(currentDate.add(Duration(days: j)), 0));
        }
      }
    }
    filledDates.add(dates.last);
    return filledDates;
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
                'GIBANJE KAPITALA',
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

                  double max = 0;
                  if (prihodkiVal > odhodkiVal) {
                    max = prihodkiVal;
                  } else {
                    max = odhodkiVal;
                  }

                  List<SalesData> sales = [];
                  List<VnosVDnevnik> vnosiPrihodki = [];
                  List<VnosVDnevnik> vnosiOdhodki = [];

                  deleteVnosi(vnosi, stDni);

                  for (int i = 0; i < vnosi.length; i++) {
                    for (int j = 0; j < prihodki.length; j++) {
                      if (vnosi[i].kontDebet == prihodki[j].ime ||
                          vnosi[i].kontKredit == prihodki[j].ime) {
                        vnosiPrihodki.add(vnosi[i]);
                      }
                    }
                  }

                  for (int i = 0; i < vnosi.length; i++) {
                    for (int j = 0; j < odhodki.length; j++) {
                      if (vnosi[i].kontDebet == odhodki[j].ime ||
                          vnosi[i].kontKredit == odhodki[j].ime) {
                        vnosiOdhodki.add(vnosi[i]);
                      }
                    }
                  }

                  buildGraph(sales, vnosiPrihodki, vnosiOdhodki);

                  sales.sort((a, b) => a.year.compareTo(b.year));

                  for (int i = 0; i < sales.length; i++) {
                    SalesData old = sales[i];
                    sales[i] = SalesData(
                        DateTime(sales[i].year.year, sales[i].year.month,
                            sales[i].year.day),
                        old.sales);
                  }

                  for (int i = 0; i < sales.length; i++) {
                    for (int j = i + 1; j < sales.length; j++) {
                      if (j == sales.length - 1) {
                        break;
                      }
                      if (isSameDay(sales[i].year, sales[j].year)) {
                        SalesData old = sales[j];
                        sales[i].sales += sales[j].sales;
                        sales.removeAt(j);
                        i = i - 1;
                        if (i == -1) {
                          i = 0;
                        }
                      }
                    }
                  }

                  sales = fillDateGaps(sales);

                  //debetItem = dropdownValue;
                  return SizedBox(
                      height: 220,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 200,
                              child: SfCartesianChart(
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  primaryXAxis: DateTimeAxis(),
                                  series: <ChartSeries>[
                                    // Renders line chart
                                    LineSeries<SalesData, DateTime>(
                                        color: Color.fromRGBO(151, 234, 137, 1),
                                        dataSource: sales,
                                        name: 'Gibanje kapitala',
                                        markerSettings:
                                            MarkerSettings(isVisible: true),
                                        xValueMapper: (SalesData sales, _) =>
                                            sales.year,
                                        yValueMapper: (SalesData sales, _) =>
                                            sales.sales)
                                  ]))
                        ],
                      ));
                }).toList(),
              );
            },
          )
          /*Container(
              height: 170,
              child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  
                  series: <ChartSeries>[
                    // Renders line chart
                    LineSeries<SalesData, DateTime>(
                        dataSource: chartData,
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales)
                  ]))*/
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  double sales;
}

class SameDay {}
