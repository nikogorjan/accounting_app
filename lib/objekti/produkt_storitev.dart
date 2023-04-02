class ProduktStoritev {
  final String ID;
  final String PS;
  final String naziv;
  final String cena;
  final String prodaja;
  final String bilanca;

  const ProduktStoritev({
    required this.ID,
    required this.PS,
    required this.naziv,
    required this.cena,
    required this.prodaja,
    required this.bilanca,
  });

  Map toJson() => {
        'ID': ID,
        'PS': PS,
        'naziv': naziv,
        'cena': cena,
        'prodaja': prodaja,
        'bilanca': bilanca,
      };

  ProduktStoritev.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        PS = json['PS'],
        naziv = json['naziv'],
        cena = json['cena'],
        prodaja = json['prodaja'],
        bilanca = json['bilanca'];
}
