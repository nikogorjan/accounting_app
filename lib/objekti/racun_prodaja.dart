class RacunProdaja {
  final String ID;
  final String stranka;
  final String kontprodaje;
  final String datum;
  final List<dynamic> prodaje;
  final String bilanca;
  final bool placan;
  final String rokPlacila;
  final String kontterjatev;

  const RacunProdaja({
    required this.ID,
    required this.stranka,
    required this.kontprodaje,
    required this.datum,
    required this.prodaje,
    required this.bilanca,
    required this.placan,
    required this.rokPlacila,
    required this.kontterjatev,
  });

  Map toJson() => {
        'ID': ID,
        'stranka': stranka,
        'kontprodaje': kontprodaje,
        'datum': datum,
        'prodaje': prodaje,
        'bilanca': bilanca,
        'placan': placan,
        'rokPlacila': rokPlacila,
        'kontterjatev': kontterjatev,
      };

  RacunProdaja.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        stranka = json['stranka'],
        kontprodaje = json['kontprodaje'],
        datum = json['datum'],
        prodaje = json['prodaje'],
        bilanca = json['bilanca'],
        placan = json['placan'],
        rokPlacila = json['rokPlacila'],
        kontterjatev = json['kontterjatev'];
}
