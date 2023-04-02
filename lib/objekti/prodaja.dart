class Prodaja {
  String ID;
  String? PS;
  String? kolicina;
  String cena;
  String DDV;
  String? vsota;
  String tip;
  String kont;

  Prodaja({
    required this.ID,
    required this.PS,
    required this.kolicina,
    required this.cena,
    required this.DDV,
    required this.vsota,
    required this.tip,
    required this.kont,
  });

  Map toJson() => {
        'ID': ID,
        'PS': PS,
        'kolicina': kolicina,
        'cena': cena,
        'DDV': DDV,
        'vsota': vsota,
        'tip': tip,
        'kont': kont,
      };

  Prodaja.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        PS = json['PS'],
        kolicina = json['kolicina'],
        cena = json['cena'],
        DDV = json['DDV'],
        tip = json['tip'],
        kont = json['kont'],
        vsota = json['vsota'];
}
