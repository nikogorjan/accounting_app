class Placa {
  final String ID;
  final String delavec;
  final String vsota;
  final String datum;

  const Placa({
    required this.ID,
    required this.delavec,
    required this.vsota,
    required this.datum,
  });

  Map toJson() => {
        'ID': ID,
        'delavec': delavec,
        'vsota': vsota,
        'datum': datum,
      };

  Placa.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        delavec = json['delavec'],
        vsota = json['vsota'],
        datum = json['datum'];
}
