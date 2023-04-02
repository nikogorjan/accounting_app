class Materiall {
  final String ID;
  String ime;
  String kolicina;

  Materiall({
    required this.ID,
    required this.ime,
    required this.kolicina,
  });

  Map toJson() => {
        'ID': ID,
        'ime': ime,
        'kolicina': kolicina,
      };

  Materiall.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        ime = json['ime'],
        kolicina = json['kolicina'];
}
