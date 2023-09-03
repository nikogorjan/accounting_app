import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/data.dart';
import '../objekti/kont.dart';

class Poopi {
  void postChanges() {
    var db = FirebaseFirestore.instance;
    String ID = box.get('email');
    final docRef = db.collection("Users").doc(ID);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      List<dynamic> accountsJson = data['konti'];

      accountsJson.add(jsonEncode(Kont(
          ID: ID,
          ime: 'ime',
          tip: 'tip',
          podtip: 'podtip',
          bilanca: 'bilanca',
          amortizacija: 'amortizacija',
          bilancaDate: 'bilancaDate',
          amortizacijaDate: 'amortizacijaDate',
          debet: 'debet',
          kredit: 'kredit')));

      FirebaseFirestore.instance
          .collection('Users')
          .doc(ID)
          .update({'konti': accountsJson});
    });
  }
}
