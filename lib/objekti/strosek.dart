class Strosek {
  String ID;
  String? IS;
  String? produkt;
  String kolicina;
  String? kont;
  String cena;

  Strosek({
    required this.ID,
    required this.IS,
    required this.produkt,
    required this.kolicina,
    required this.kont,
    required this.cena,
  });

  Map toJson() => {
        'ID': ID,
        'IS': IS,
        'produkt': produkt,
        'kolicina': kolicina,
        'kont': kont,
        'cena': cena,
      };

  Strosek.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        IS = json['IS'],
        produkt = json['produkt'],
        kolicina = json['kolicina'],
        kont = json['kont'],
        cena = json['cena'];
}
