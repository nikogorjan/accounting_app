class Transakcija {
  final String ID;
  final String opis;
  final String datum;
  final String kont;
  final String prejemnikPlacila;
  final String prejeto;
  final String placilo;

  const Transakcija({
    required this.ID,
    required this.opis,
    required this.datum,
    required this.kont,
    required this.prejemnikPlacila,
    required this.prejeto,
    required this.placilo,
  });

  Map toJson() => {
        'ID': ID,
        'opis': opis,
        'datum': datum,
        'kont': kont,
        'prejemnikPlacila': prejemnikPlacila,
        'prejeto': prejeto,
        'placilo': placilo,
      };

  Transakcija.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        opis = json['opis'],
        datum = json['datum'],
        kont = json['kont'],
        prejemnikPlacila = json['prejemnikPlacila'],
        prejeto = json['prejeto'],
        placilo = json['placilo'];
}
