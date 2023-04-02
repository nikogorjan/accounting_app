class Plan {
  final String ID;
  final String ime;
  final bool slika;
  final List<dynamic> material;
  final String kont;

  const Plan({
    required this.ID,
    required this.ime,
    required this.slika,
    required this.material,
    required this.kont,
  });

  Map toJson() => {
        'ID': ID,
        'ime': ime,
        'slika': slika,
        'material': material,
        'kont': kont,
      };

  Plan.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        ime = json['ime'],
        slika = json['slika'],
        kont = json['kont'],
        material = json['material'];
}
