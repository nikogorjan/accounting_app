import 'package:flutter/material.dart';

class Kont {
  String ID;
  String ime;
  String tip;
  String podtip;
  String bilanca;
  String amortizacija;
  String bilancaDate;
  String amortizacijaDate;
  String debet;
  String kredit;

  Kont({
    required this.ID,
    required this.ime,
    required this.tip,
    required this.podtip,
    required this.bilanca,
    required this.amortizacija,
    required this.bilancaDate,
    required this.amortizacijaDate,
    required this.debet,
    required this.kredit,
  });

  void changeBalance(double debet, double kredit) {
    this.kredit = (double.parse(this.kredit) + kredit).toString();
    this.debet = (double.parse(this.debet) + debet).toString();
    double balance = 0;
    if (double.parse(this.kredit) > double.parse(this.debet)) {
      balance = double.parse(this.kredit) - double.parse(this.debet);
    } else {
      balance = double.parse(this.debet) - double.parse(this.kredit);
    }

    this.bilanca = balance.toString();
  }

  Map toJson() => {
        'ID': ID,
        'ime': ime,
        'tip': tip,
        'podtip': podtip,
        'bilanca': bilanca,
        'amortizacija': amortizacija,
        'bilancaDate': bilancaDate,
        'amortizacijaDate': amortizacijaDate,
        'debet': debet,
        'kredit': kredit,
      };

  Kont.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        ime = json['ime'],
        tip = json['tip'],
        podtip = json['podtip'],
        bilanca = json['bilanca'],
        amortizacija = json['amortizacija'],
        bilancaDate = json['bilancaDate'],
        debet = json['debet'],
        kredit = json['kredit'],
        amortizacijaDate = json['amortizacijaDate'];
}
