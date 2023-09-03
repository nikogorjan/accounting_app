class RacunStrosek {
  final String ID;
  final String dobavitelj;
  final String kontPlacila;
  final String datum;
  final List<dynamic> stroski;
  final String bilanca;
  final bool placan;
  final String rokPlacila;
  final String kontObveznost;

  const RacunStrosek({
    required this.ID,
    required this.dobavitelj,
    required this.kontPlacila,
    required this.datum,
    required this.stroski,
    required this.bilanca,
    required this.placan,
    required this.rokPlacila,
    required this.kontObveznost,
  });

  Map toJson() => {
        'ID': ID,
        'dobavitelj': dobavitelj,
        'kontPlacila': kontPlacila,
        'datum': datum,
        'stroski': stroski,
        'bilanca': bilanca,
        'placan': placan,
        'rokPlacila': rokPlacila,
        'kontObveznost': kontObveznost,
      };

  RacunStrosek.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        dobavitelj = json['dobavitelj'],
        kontPlacila = json['kontPlacila'],
        datum = json['datum'],
        stroski = json['stroski'],
        bilanca = json['bilanca'],
        placan = json['placan'],
        rokPlacila = json['rokPlacila'],
        kontObveznost = json['kontObveznost'];
}
