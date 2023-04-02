class Storitev {
  final String ID;
  final String ime;
  final String dobavitelj;
  final String komentar;
  final String stnakupov;
  final String bilanca;

  const Storitev({
    required this.ID,
    required this.ime,
    required this.dobavitelj,
    required this.komentar,
    required this.stnakupov,
    required this.bilanca,
  });

  Map toJson() => {
        'ID': ID,
        'ime': ime,
        'dobavitelj': dobavitelj,
        'komentar': komentar,
        'stnakupov': stnakupov,
        'bilanca': bilanca,
      };

  Storitev.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        ime = json['ime'],
        dobavitelj = json['dobavitelj'],
        komentar = json['komentar'],
        stnakupov = json['stnakupov'],
        bilanca = json['bilanca'];
}
