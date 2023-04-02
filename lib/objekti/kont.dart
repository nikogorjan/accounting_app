import 'package:flutter/material.dart';

class Kont {
  final String ID;
  final String ime;
  final String tip;
  final String podtip;
  final String bilanca;
  final String amortizacija;
  final String bilancaDate;
  final String amortizacijaDate;
  final String debet;
  final String kredit;

  const Kont({
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
