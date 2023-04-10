import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../objekti/banka.dart';
import '../../../objekti/transakcija.dart';

class BankaPodatki extends StatefulWidget {
  const BankaPodatki({super.key, required this.banka});
  final Banka banka;

  @override
  State<BankaPodatki> createState() => _BankaPodatkiState();
}

class _BankaPodatkiState extends State<BankaPodatki> {
  List<Transakcija> transactions = [];

  List<Transakcija> transactions7 = [];

  void exportTransactions() {
    List<dynamic> transakcije = widget.banka.transakcije;
    for (int j = 0; j < transakcije.length; j++) {
      Map<String, dynamic> valueMap = json.decode(transakcije[j]);
      Transakcija NewAccount = Transakcija.fromJson(valueMap);
      transactions.add(NewAccount);
    }
    transactions.sort(
      (a, b) => a.datum.compareTo(b.datum),
    );
    transactions = transactions.reversed.toList();

    if (transactions.length < 7) {
      for (int i = 0; i < transactions.length; i++) {
        transactions7.add(transactions[i]);
      }
    } else {
      for (int i = 0; i < 7; i++) {
        transactions7.add(transactions[i]);
      }
    }
  }

  @override
  initState() {
    exportTransactions();
    super.initState();
    // Add listeners to this class
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      color: Colors.black,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'BANKA',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'OpenSans', fontSize: 32),
              ),
            ],
          ),
          Divider(
            color: Colors.white,
          ),
          Row(
            children: [
              Text(
                widget.banka.ime,
                style: TextStyle(
                    color: Colors.white, fontFamily: 'OpenSans', fontSize: 18),
              ),
              Spacer(),
              Text(
                '€' + double.parse(widget.banka.bilanca).toStringAsFixed(2),
                style: TextStyle(
                    color: Colors.white, fontFamily: 'OpenSans', fontSize: 32),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                'Zadnjih 7 transakcij',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'OpenSans', fontSize: 12),
              )
            ],
          ),
          Divider(
            color: Colors.white,
          ),
          Container(
            height: 170,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: transactions7.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transactions7[index].prejemnikPlacila,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: 12),
                              ),
                              Text(
                                "${(DateTime.parse(transactions7[index].datum)).day}. ${(DateTime.parse(transactions7[index].datum)).month}. ${(DateTime.parse(transactions7[index].datum)).year}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: 12),
                              )
                            ],
                          ),
                          Spacer(),
                          if (transactions7[index].prejeto == '') ...[
                            Text(
                              '- €' +
                                  double.parse(transactions7[index].placilo)
                                      .toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontSize: 18),
                            )
                          ] else ...[
                            Text(
                              '+ €' +
                                  double.parse(transactions7[index].prejeto)
                                      .toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontSize: 18),
                            )
                          ]
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
