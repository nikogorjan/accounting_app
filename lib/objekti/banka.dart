import 'package:cloud_firestore/cloud_firestore.dart';

class Banka {
  final String ID;
  final String ime;
  final String bilanca;
  final List<String> transakcije;

  const Banka({
    required this.ID,
    required this.ime,
    required this.bilanca,
    required this.transakcije,
  });

  Map toJson() =>
      {'ID': ID, 'ime': ime, 'bilanca': bilanca, 'transakcije': transakcije};

  Banka.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        ime = json['ime'],
        bilanca = json['bilanca'],
        transakcije = json['transakcije'];
}
