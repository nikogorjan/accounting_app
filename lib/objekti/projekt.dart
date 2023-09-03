class Projekt {
  final String ID;
  final String ime;
  final bool slika;
  final List<dynamic> material;

  const Projekt({
    required this.ID,
    required this.ime,
    required this.slika,
    required this.material,
  });

  Map toJson() => {
        'ID': ID,
        'ime': ime,
        'slika': slika,
        'material': material,
      };

  Projekt.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        ime = json['ime'],
        slika = json['slika'],
        material = json['material'];
}
