class Delo {
  final String ID;
  final String datum;
  final String stUr;
  final String delavec;

  const Delo({
    required this.ID,
    required this.datum,
    required this.stUr,
    required this.delavec,
  });

  Map toJson() => {
        'ID': ID,
        'datum': datum,
        'stUr': stUr,
        'delavec': delavec,
      };

  Delo.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        datum = json['datum'],
        delavec = json['delavec'],
        stUr = json['stUr'];
}
