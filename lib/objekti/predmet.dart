class Predmet {
  final String ID;
  final String ime;
  final String kolicina;
  final String enota;
  final bool slika;
  final String bilanca;
  final String tip;
  final String kont;

  const Predmet({
    required this.ID,
    required this.ime,
    required this.kolicina,
    required this.enota,
    required this.slika,
    required this.bilanca,
    required this.tip,
    required this.kont,
  });

  Map toJson() => {
        'ID': ID,
        'ime': ime,
        'kolicina': kolicina,
        'enota': enota,
        'slika': slika,
        'bilanca': bilanca,
        'tip': tip,
        'kont': kont,
      };

  Predmet.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        ime = json['ime'],
        kolicina = json['kolicina'],
        enota = json['enota'],
        slika = json['slika'],
        tip = json['tip'],
        kont = json['kont'],
        bilanca = json['bilanca'];
}
