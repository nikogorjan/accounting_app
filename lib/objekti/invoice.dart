import 'package:accounting_app/objekti/racun_prodaja.dart';
import 'package:accounting_app/objekti/stranka.dart';
import 'package:flutter/material.dart';

class Invoice {
  final String ID;
  final RacunProdaja racun;
  final Stranka stranka;
  final String izdajateljIme;
  final String izdajateljPodjetje;

  const Invoice({
    required this.ID,
    required this.racun,
    required this.stranka,
    required this.izdajateljIme,
    required this.izdajateljPodjetje,
  });

  Map toJson() => {
        'ID': ID,
        'racun': racun,
        'stranka': stranka,
        'izdajateljIme': izdajateljIme,
        'izdajateljPodjetje': izdajateljPodjetje,
      };

  Invoice.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        racun = json['racun'],
        stranka = json['stranka'],
        izdajateljIme = json['izdajateljIme'],
        izdajateljPodjetje = json['izdajateljPodjetje'];
}
