import 'package:cloud_firestore/cloud_firestore.dart';

class Banka {
  final String ID;
  final String ime;
  final String bilanca;
  final List<dynamic> transakcije;
  final bool selected;

  const Banka({
    required this.ID,
    required this.ime,
    required this.bilanca,
    required this.transakcije,
    required this.selected,
  });

  Map toJson() => {
        'ID': ID,
        'ime': ime,
        'bilanca': bilanca,
        'transakcije': transakcije,
        'selected': selected
      };

  Banka.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        ime = json['ime'],
        bilanca = json['bilanca'],
        transakcije = json['transakcije'],
        selected = json['selected'];
}
