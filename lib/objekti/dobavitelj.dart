class Dobavitelj {
  final String ID;
  final String naziv;
  final String naslov;
  final String tel;
  final String email;
  final String bilanca;

  final List<dynamic> transakcije;

  const Dobavitelj({
    required this.ID,
    required this.naziv,
    required this.naslov,
    required this.tel,
    required this.email,
    required this.bilanca,
    required this.transakcije,
  });

  Map toJson() => {
        'ID': ID,
        'naziv': naziv,
        'naslov': naslov,
        'tel': tel,
        'email': email,
        'bilanca': bilanca,
        'transakcije': transakcije
      };

  Dobavitelj.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        naziv = json['naziv'],
        naslov = json['naslov'],
        tel = json['tel'],
        email = json['email'],
        bilanca = json['bilanca'],
        transakcije = json['transakcije'];
}
